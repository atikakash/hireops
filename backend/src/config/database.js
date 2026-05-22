require('dotenv').config();

const usePostgres =
  process.env.DB_CLIENT === 'postgres' || Boolean(process.env.DATABASE_URL);

if (usePostgres) {
  const { Pool } = require('pg');
  const normalizedDatabaseUrl = normalizePostgresUrl(process.env.DATABASE_URL);

  const pool = new Pool({
    connectionString: normalizedDatabaseUrl,
    host: process.env.DATABASE_URL ? undefined : process.env.DB_HOST,
    port: process.env.DATABASE_URL ? undefined : Number(process.env.DB_PORT || 5432),
    user: process.env.DATABASE_URL ? undefined : process.env.DB_USER,
    password: process.env.DATABASE_URL ? undefined : process.env.DB_PASSWORD,
    database: process.env.DATABASE_URL ? undefined : process.env.DB_NAME,
    max: Number(process.env.DB_CONNECTION_LIMIT || 10),
    ssl:
      process.env.DB_SSL === 'false'
        ? false
        : { rejectUnauthorized: false },
  });

  const compatPool = createPostgresCompatPool(pool);
  compatPool.isPostgres = true;
  compatPool.configSummary = summarizePostgresUrl(process.env.DATABASE_URL, normalizedDatabaseUrl);
  module.exports = compatPool;
} else {
  const mysql = require('mysql2/promise');

  const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'hireops_db',
    waitForConnections: true,
    connectionLimit: Number(process.env.DB_CONNECTION_LIMIT || 10),
    queueLimit: 0,
    namedPlaceholders: true,
  });
  pool.isPostgres = false;
  pool.configSummary = {
    client: 'mysql',
    host: process.env.DB_HOST || 'localhost',
    port: String(process.env.DB_PORT || 3306),
    username: process.env.DB_USER || 'root',
  };
  module.exports = pool;
}

function normalizePostgresUrl(connectionString) {
  if (!connectionString) {
    return connectionString;
  }

  try {
    const url = new URL(connectionString);
    const isSupabasePooler = url.hostname.endsWith('.pooler.supabase.com');
    const projectRef = process.env.SUPABASE_PROJECT_REF || 'ovspucdlfhwbqdsnkuqg';

    if (isSupabasePooler && url.username === 'postgres') {
      url.username = `postgres.${projectRef}`;
      console.warn('[database] normalized Supabase pooler username');
    }

    return url.toString();
  } catch (_err) {
    return connectionString;
  }
}

function summarizePostgresUrl(originalConnectionString, normalizedConnectionString) {
  const summary = {
    client: 'postgres',
    hasDatabaseUrl: Boolean(originalConnectionString),
    host: null,
    port: null,
    username: null,
    normalizedUsername: null,
  };

  try {
    const original = originalConnectionString ? new URL(originalConnectionString) : null;
    const normalized = normalizedConnectionString ? new URL(normalizedConnectionString) : null;
    summary.host = original?.hostname || process.env.DB_HOST || null;
    summary.port = original?.port || process.env.DB_PORT || null;
    summary.username = original?.username || process.env.DB_USER || null;
    summary.normalizedUsername = normalized?.username || summary.username;
  } catch (_err) {
    summary.username = process.env.DB_USER || null;
    summary.normalizedUsername = summary.username;
  }

  return summary;
}

function createPostgresCompatPool(pool) {
  return {
    async query(sql, params = []) {
      const result = await pool.query(toPostgresQuery(sql), params);
      return [decorateResultRows(result), result.fields];
    },

    async getConnection() {
      const client = await pool.connect();
      return createPostgresCompatClient(client);
    },

    async end() {
      await pool.end();
    },
  };
}

function createPostgresCompatClient(client) {
  return {
    async query(sql, params = []) {
      const result = await client.query(toPostgresQuery(sql), params);
      return [decorateResultRows(result), result.fields];
    },

    async beginTransaction() {
      await client.query('BEGIN');
    },

    async commit() {
      await client.query('COMMIT');
    },

    async rollback() {
      await client.query('ROLLBACK');
    },

    release() {
      client.release();
    },
  };
}

function decorateResultRows(result) {
  const rows = result.rows || [];
  rows.insertId = rows[0]?.id;
  rows.affectedRows = result.rowCount || 0;
  return rows;
}

function toPostgresQuery(sql) {
  let converted = convertPlaceholders(sql);
  converted = addReturningId(converted);
  return converted;
}

function convertPlaceholders(sql) {
  let index = 0;
  let output = '';
  let quote = null;

  for (let i = 0; i < sql.length; i += 1) {
    const char = sql[i];
    const prev = sql[i - 1];

    if ((char === "'" || char === '"') && prev !== '\\') {
      quote = quote === char ? null : quote || char;
    }

    if (char === '?' && quote === null) {
      index += 1;
      output += `$${index}`;
    } else {
      output += char;
    }
  }

  return output;
}

function addReturningId(sql) {
  const normalized = sql.trim().toLowerCase();
  if (!normalized.startsWith('insert') || normalized.includes(' returning ')) {
    return sql;
  }

  return `${sql} RETURNING id`;
}
