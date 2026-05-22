require('dotenv').config();

const usePostgres =
  process.env.DB_CLIENT === 'postgres' || Boolean(process.env.DATABASE_URL);

if (usePostgres) {
  const { Pool } = require('pg');

  const pool = new Pool({
    connectionString: process.env.DATABASE_URL,
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
  module.exports = pool;
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
