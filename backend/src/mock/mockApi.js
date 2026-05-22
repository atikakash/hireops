const express = require('express');

const router = express.Router();

const stageCatalog = [
  { id: 'stage-1', stage: 'applied', name: 'Applied', order: 0 },
  { id: 'stage-2', stage: 'shortlisted', name: 'Shortlisted', order: 1 },
  { id: 'stage-3', stage: 'interview', name: 'Interview', order: 2 },
  { id: 'stage-4', stage: 'hired', name: 'Hired', order: 3 },
  { id: 'stage-5', stage: 'rejected', name: 'Rejected', order: 4 },
];

const counters = {
  user: 2,
  candidate: 3,
  note: 2,
  job: 2,
  activity: 5,
  notification: 3,
  cv: 1,
  refresh: 0,
  access: 0,
};

const state = {
  company: {
    id: 'company-1',
    name: 'HireOps Demo',
    slug: 'hireops-demo',
    email: 'hello@hireops.io',
    phone: '+1 555-0100',
    website: 'https://hireops.io',
    industry: 'Recruiting Software',
    logo: null,
    address: 'Dhaka, Bangladesh',
    is_active: true,
    created_at: isoDaysAgo(90),
  },
  users: [
    {
      id: 'user-1',
      name: 'Admin User',
      email: 'admin@hireops.io',
      password: 'password123',
      role: 'admin',
      avatar_url: null,
    },
    {
      id: 'user-2',
      name: 'Recruiter One',
      email: 'recruiter@hireops.io',
      password: 'password123',
      role: 'recruiter',
      avatar_url: null,
    },
  ],
  notificationSettings: {
    cvUploadedEmail: true,
    stageMovedEmail: true,
    jobAssignedEmail: true,
    pushEnabled: true,
  },
  sessions: new Map(),
  refreshSessions: new Map(),
  passwordResetOtps: new Map(),
  cvs: [
    {
      id: 'cv-1',
      fileName: 'sadia-khan-cv.pdf',
      fileUrl:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      fileSizeBytes: 245760,
      mimeType: 'application/pdf',
      candidateId: 'candidate-1',
      uploadedAt: isoDaysAgo(7),
    },
  ],
  candidates: [
    {
      id: 'candidate-1',
      name: 'Sadia Khan',
      email: 'sadia.khan@example.com',
      phone: '+8801711000001',
      experienceYears: 5,
      skills: ['Flutter', 'Dart', 'Firebase'],
      tags: ['mobile', 'senior'],
      notes: [
        {
          id: 'note-1',
          content: 'Strong portfolio and good communication.',
          authorName: 'Admin User',
          createdAt: isoDaysAgo(5),
          updatedAt: isoDaysAgo(5),
        },
      ],
      stageHistory: [
        {
          id: 'history-1',
          stage: 'applied',
          movedByName: 'Admin User',
          movedAt: isoDaysAgo(7),
          note: 'Imported from CV upload.',
        },
        {
          id: 'history-2',
          stage: 'shortlisted',
          movedByName: 'Recruiter One',
          movedAt: isoDaysAgo(3),
          note: 'Passed initial screening.',
        },
      ],
      currentStage: 'shortlisted',
      cvUrl:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      cvId: 'cv-1',
      jobId: 'job-1',
      jobTitle: 'Senior Flutter Developer',
      avatarUrl: null,
      createdAt: isoDaysAgo(7),
      updatedAt: isoDaysAgo(3),
    },
    {
      id: 'candidate-2',
      name: 'Rahim Ahmed',
      email: 'rahim.ahmed@example.com',
      phone: '+8801711000002',
      experienceYears: 3,
      skills: ['React', 'TypeScript', 'Node.js'],
      tags: ['frontend'],
      notes: [],
      stageHistory: [
        {
          id: 'history-3',
          stage: 'applied',
          movedByName: 'Admin User',
          movedAt: isoDaysAgo(2),
          note: 'Applied for frontend role.',
        },
      ],
      currentStage: 'applied',
      cvUrl:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      cvId: null,
      jobId: null,
      jobTitle: null,
      avatarUrl: null,
      createdAt: isoDaysAgo(2),
      updatedAt: isoDaysAgo(2),
    },
    {
      id: 'candidate-3',
      name: 'Nusrat Jahan',
      email: 'nusrat.jahan@example.com',
      phone: '+8801711000003',
      experienceYears: 6,
      skills: ['Product Design', 'Figma', 'Design Systems'],
      tags: ['design', 'lead'],
      notes: [],
      stageHistory: [
        {
          id: 'history-4',
          stage: 'applied',
          movedByName: 'Recruiter One',
          movedAt: isoDaysAgo(4),
        },
        {
          id: 'history-5',
          stage: 'interview',
          movedByName: 'Admin User',
          movedAt: isoDaysAgo(1),
          note: 'Portfolio review scheduled.',
        },
      ],
      currentStage: 'interview',
      cvUrl:
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      cvId: null,
      jobId: 'job-2',
      jobTitle: 'Product Designer',
      avatarUrl: null,
      createdAt: isoDaysAgo(4),
      updatedAt: isoDaysAgo(1),
    },
  ],
  jobs: [
    {
      id: 'job-1',
      title: 'Senior Flutter Developer',
      department: 'Engineering',
      description: 'Build and maintain the HireOps mobile app.',
      status: 'open',
      openDate: isoDaysAgo(20),
      candidateCount: 1,
      assignedCandidateIds: ['candidate-1'],
      closedDate: null,
      createdAt: isoDaysAgo(20),
    },
    {
      id: 'job-2',
      title: 'Product Designer',
      department: 'Design',
      description: 'Lead product design and design system work.',
      status: 'open',
      openDate: isoDaysAgo(12),
      candidateCount: 1,
      assignedCandidateIds: ['candidate-3'],
      closedDate: null,
      createdAt: isoDaysAgo(12),
    },
  ],
  notifications: [
    {
      id: 'notification-1',
      title: 'Candidate moved to interview',
      body: 'Nusrat Jahan was moved to Interview.',
      type: 'stageMoved',
      createdAt: isoDaysAgo(1),
      isRead: false,
      candidateId: 'candidate-3',
      jobId: 'job-2',
    },
    {
      id: 'notification-2',
      title: 'New candidate created',
      body: 'Rahim Ahmed was added to your workspace.',
      type: 'cvUploaded',
      createdAt: isoDaysAgo(2),
      isRead: false,
      candidateId: 'candidate-2',
      jobId: null,
    },
    {
      id: 'notification-3',
      title: 'Candidate assigned to job',
      body: 'Sadia Khan was assigned to Senior Flutter Developer.',
      type: 'jobAssigned',
      createdAt: isoDaysAgo(3),
      isRead: true,
      candidateId: 'candidate-1',
      jobId: 'job-1',
    },
  ],
  activities: [
    {
      id: 'activity-1',
      action: 'created candidate',
      actorName: 'Admin User',
      targetName: 'Sadia Khan',
      createdAt: isoDaysAgo(7),
      type: 'candidateAdded',
      candidateId: 'candidate-1',
      jobId: null,
    },
    {
      id: 'activity-2',
      action: 'moved candidate to shortlisted',
      actorName: 'Recruiter One',
      targetName: 'Sadia Khan',
      createdAt: isoDaysAgo(3),
      type: 'stageMoved',
      candidateId: 'candidate-1',
      jobId: 'job-1',
    },
    {
      id: 'activity-3',
      action: 'created job',
      actorName: 'Admin User',
      targetName: 'Product Designer',
      createdAt: isoDaysAgo(12),
      type: 'jobCreated',
      candidateId: null,
      jobId: 'job-2',
    },
    {
      id: 'activity-4',
      action: 'added note',
      actorName: 'Admin User',
      targetName: 'Sadia Khan',
      createdAt: isoDaysAgo(5),
      type: 'noteAdded',
      candidateId: 'candidate-1',
      jobId: null,
    },
    {
      id: 'activity-5',
      action: 'moved candidate to interview',
      actorName: 'Admin User',
      targetName: 'Nusrat Jahan',
      createdAt: isoDaysAgo(1),
      type: 'stageMoved',
      candidateId: 'candidate-3',
      jobId: 'job-2',
    },
  ],
};

router.post('/auth/login', (req, res) => {
  const email = normalizeEmail(req.body.email);
  const password = stringValue(req.body.password);
  if (!isValidEmail(email)) {
    return validationFailed(res, {
      email: ['Enter a valid email address.'],
    });
  }

  const user = state.users.find((item) => item.email.toLowerCase() === email);

  if (!user || user.password !== password) {
    return res.status(401).json({
      success: false,
      message: 'Invalid email or password.',
    });
  }

  return res.json(successAuthPayload(user));
});

router.post('/auth/register', (req, res) => {
  const email = normalizeEmail(req.body.email);
  const companyEmail = normalizeEmail(req.body.company_email || email);
  const errors = {};
  if (!isValidEmail(email)) {
    errors.email = ['Enter a valid email address.'];
  }
  if (!isValidEmail(companyEmail)) {
    errors.company_email = ['Enter a valid company email address.'];
  }
  if (Object.keys(errors).length) {
    return validationFailed(res, errors);
  }

  const existing = state.users.find((item) => item.email.toLowerCase() === email);
  if (existing) {
    return validationFailed(res, {
      email: ['Email is already registered.'],
    });
  }

  const user = {
    id: nextId('user'),
    name: stringValue(req.body.name) || 'New User',
    email,
    password: stringValue(req.body.password) || 'password123',
    role: 'admin',
    avatar_url: null,
  };

  state.users.unshift(user);
  state.company = {
    ...state.company,
    name: stringValue(req.body.company_name) || state.company.name,
    slug: slugify(stringValue(req.body.company_name) || state.company.name),
    email: companyEmail,
    phone: nullableString(req.body.company_phone) || state.company.phone,
    website: nullableString(req.body.company_website) || state.company.website,
    industry:
        nullableString(req.body.company_industry) || state.company.industry,
    address:
        nullableString(req.body.company_address) || state.company.address,
  };

  addActivity({
    action: 'created company account',
    actorName: user.name,
    targetName: state.company.name,
    type: 'candidateAdded',
  });

  return res.status(201).json(successAuthPayload(user));
});

router.post('/auth/forgot-password', (req, res) => {
  const email = normalizeEmail(req.body.email);
  if (!isValidEmail(email)) {
    return validationFailed(res, {
      email: ['Enter a valid email address.'],
    });
  }

  const otp = '123456';
  state.passwordResetOtps.set(email, otp);
  return res.json({
    success: true,
    message: 'If that email exists, a reset OTP has been sent.',
    debug_otp: otp,
  });
});

router.post('/auth/reset-password', (req, res) => {
  const email = normalizeEmail(req.body.email);
  const otp = stringValue(req.body.otp);
  const newPassword = stringValue(req.body.password);
  if (!isValidEmail(email)) {
    return validationFailed(res, {
      email: ['Enter a valid email address.'],
    });
  }

  const expectedOtp = state.passwordResetOtps.get(email);
  const user = state.users.find((item) => item.email.toLowerCase() === email);

  if (!user) {
    return res.status(404).json({
      success: false,
      message: 'User not found.',
    });
  }

  if (expectedOtp && otp !== expectedOtp) {
    return res.status(422).json({
      success: false,
      message: 'Invalid OTP.',
    });
  }

  user.password = newPassword || 'password123';
  state.passwordResetOtps.delete(email);
  return res.json({
    success: true,
    message: 'Password reset successfully.',
  });
});

router.post('/auth/refresh', (req, res) => {
  const refreshToken = stringValue(req.body.refreshToken);
  const userId = state.refreshSessions.get(refreshToken);
  const user = state.users.find((item) => item.id === userId);

  if (!user) {
    return res.status(401).json({
      success: false,
      message: 'Invalid refresh token.',
    });
  }

  const session = issueSession(user);
  return res.json({
    accessToken: session.accessToken,
    refreshToken: session.refreshToken,
  });
});

router.post('/auth/logout', requireAuth, (req, res) => {
  revokeAccessToken(req.token);
  return res.json({
    success: true,
    message: 'Logged out.',
  });
});

router.use(requireAuth);

router.get('/company', (_req, res) => {
  return res.json({
    success: true,
    data: {
      company: state.company,
      members: teamMembers(),
    },
  });
});

router.put('/company', (req, res) => {
  state.company = {
    ...state.company,
    name: stringValue(req.body.name) || state.company.name,
    slug: slugify(stringValue(req.body.name) || state.company.name),
    email: stringValue(req.body.email) || state.company.email,
    phone: nullableString(req.body.phone),
    website: nullableString(req.body.website),
    industry: nullableString(req.body.industry),
    address: nullableString(req.body.address),
  };

  return res.json({
    success: true,
    message: 'Company profile updated successfully.',
    data: {
      company: state.company,
      members: teamMembers(),
    },
  });
});

router.get('/company/members', (_req, res) => {
  return res.json({
    success: true,
    data: {
      members: teamMembers(),
    },
  });
});

router.get('/dashboard/stats', (_req, res) => {
  return res.json({
    success: true,
    data: {
      stats: dashboardStats(),
    },
  });
});

router.get('/dashboard/recent-activity', (_req, res) => {
  return res.json({
    success: true,
    data: {
      activities: state.activities.slice(0, 10).map(toActivityResponse),
    },
  });
});

router.get('/candidates', (req, res) => {
  const q = stringValue(req.query.q).toLowerCase();
  const tag = nullableString(req.query.tag);
  const minExp = req.query.minExp ? Number(req.query.minExp) : null;
  const maxExp = req.query.maxExp ? Number(req.query.maxExp) : null;
  const stage = nullableString(req.query.stage);

  let candidates = [...state.candidates];
  if (q) {
    candidates = candidates.filter((candidate) =>
      [candidate.name, candidate.email, candidate.jobTitle]
        .filter(Boolean)
        .join(' ')
        .toLowerCase()
        .includes(q)
    );
  }
  if (tag) {
    candidates = candidates.filter((candidate) => candidate.tags.includes(tag));
  }
  if (minExp !== null) {
    candidates = candidates.filter(
      (candidate) => candidate.experienceYears >= minExp
    );
  }
  if (maxExp !== null) {
    candidates = candidates.filter(
      (candidate) => candidate.experienceYears <= maxExp
    );
  }
  if (stage) {
    candidates = candidates.filter(
      (candidate) => candidate.currentStage === stage
    );
  }

  return res.json({
    success: true,
    data: {
      candidates: candidates.map((candidate) => ({ ...candidate })),
    },
  });
});

router.get('/candidates/:id', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  return res.json({
    success: true,
    data: {
      candidate: { ...candidate },
    },
  });
});

router.post('/candidates', (req, res) => {
  const candidate = {
    id: nextId('candidate'),
    name: stringValue(req.body.name) || 'New Candidate',
    email: stringValue(req.body.email) || `candidate${counters.candidate}@hireops.io`,
    phone: nullableString(req.body.phone),
    experienceYears: Number(req.body.experienceYears || 0),
    skills: normalizeStringList(req.body.skills),
    tags: normalizeStringList(req.body.tags),
    notes: [],
    stageHistory: [
      {
        id: `history-${Date.now()}`,
        stage: 'applied',
        movedByName: req.user.name,
        movedAt: new Date().toISOString(),
      },
    ],
    currentStage: 'applied',
    cvUrl: null,
    cvId: null,
    jobId: null,
    jobTitle: null,
    avatarUrl: null,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  state.candidates.unshift(candidate);
  addActivity({
    action: 'created candidate',
    actorName: req.user.name,
    targetName: candidate.name,
    type: 'candidateAdded',
    candidateId: candidate.id,
  });
  pushNotification({
    title: 'New candidate created',
    body: `${candidate.name} was added to your workspace.`,
    type: 'cvUploaded',
    candidateId: candidate.id,
  });

  return res.status(201).json({
    success: true,
    data: {
      candidate,
    },
  });
});

router.put('/candidates/:id', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  if (req.body.name !== undefined) {
    candidate.name = stringValue(req.body.name) || candidate.name;
  }
  if (req.body.email !== undefined) {
    candidate.email = stringValue(req.body.email) || candidate.email;
  }
  if (req.body.phone !== undefined) {
    candidate.phone = nullableString(req.body.phone);
  }
  if (req.body.experienceYears !== undefined) {
    candidate.experienceYears = Number(req.body.experienceYears || 0);
  }
  if (req.body.skills !== undefined) {
    candidate.skills = normalizeStringList(req.body.skills);
  }
  candidate.updatedAt = new Date().toISOString();

  return res.json({
    success: true,
    data: {
      candidate,
    },
  });
});

router.delete('/candidates/:id', (req, res) => {
  const index = state.candidates.findIndex((candidate) => candidate.id === req.params.id);
  if (index === -1) {
    return notFound(res, 'Candidate not found.');
  }

  const [candidate] = state.candidates.splice(index, 1);
  state.jobs.forEach((job) => {
    job.assignedCandidateIds = job.assignedCandidateIds.filter(
      (id) => id !== candidate.id
    );
    job.candidateCount = job.assignedCandidateIds.length;
  });

  return res.json({
    success: true,
    message: 'Candidate deleted.',
  });
});

router.post('/candidates/:id/tags', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  const tag = stringValue(req.body.tag);
  if (tag && !candidate.tags.includes(tag)) {
    candidate.tags.push(tag);
    candidate.updatedAt = new Date().toISOString();
  }

  return res.json({
    success: true,
    data: {
      candidate,
    },
  });
});

router.delete('/candidates/:id/tags', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  const tag = stringValue(req.body.tag);
  candidate.tags = candidate.tags.filter((item) => item !== tag);
  candidate.updatedAt = new Date().toISOString();

  return res.json({
    success: true,
    data: {
      candidate,
    },
  });
});

router.post('/candidates/:id/notes', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  const note = {
    id: nextId('note'),
    content: stringValue(req.body.content) || 'New note',
    authorName: req.user.name,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  candidate.notes.unshift(note);
  candidate.updatedAt = new Date().toISOString();
  addActivity({
    action: 'added note',
    actorName: req.user.name,
    targetName: candidate.name,
    type: 'noteAdded',
    candidateId: candidate.id,
  });

  return res.status(201).json({
    success: true,
    data: {
      note,
    },
  });
});

router.delete('/candidates/:id/notes/:nid', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  candidate.notes = candidate.notes.filter((note) => note.id !== req.params.nid);
  candidate.updatedAt = new Date().toISOString();

  return res.json({
    success: true,
    message: 'Note deleted.',
  });
});

router.get('/candidates/:id/activity', (req, res) => {
  const activities = state.activities
    .filter((activity) => activity.candidateId === req.params.id)
    .map(toActivityResponse);

  return res.json({
    success: true,
    data: {
      activities,
    },
  });
});

router.post('/cv/upload', (req, res) => {
  const cv = {
    id: nextId('cv'),
    fileName: 'uploaded-cv.pdf',
    fileUrl:
        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    fileSizeBytes: 123456,
    mimeType: 'application/pdf',
    candidateId: null,
    uploadedAt: new Date().toISOString(),
  };

  state.cvs.unshift(cv);
  addActivity({
    action: 'uploaded cv',
    actorName: req.user.name,
    targetName: cv.fileName,
    type: 'cvUploaded',
  });
  pushNotification({
    title: 'CV uploaded',
    body: `${req.user.name} uploaded ${cv.fileName}.`,
    type: 'cvUploaded',
  });

  return res.status(201).json({
    success: true,
    data: {
      cv,
    },
  });
});

router.get('/cv/:id/download', (req, res) => {
  const cv = state.cvs.find((item) => item.id === req.params.id);
  return res.json({
    success: true,
    data: {
      url: cv?.fileUrl ||
          'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
    },
  });
});

router.get('/jobs', (req, res) => {
  const status = nullableString(req.query.status);
  const jobs = status
      ? state.jobs.filter((job) => job.status === status)
      : state.jobs;

  return res.json({
    success: true,
    data: {
      jobs: jobs.map((job) => ({ ...job })),
    },
  });
});

router.get('/jobs/:id', (req, res) => {
  const job = findJob(req.params.id);
  if (!job) {
    return notFound(res, 'Job not found.');
  }

  return res.json({
    success: true,
    data: {
      job: { ...job },
    },
  });
});

router.post('/jobs', (req, res) => {
  const job = {
    id: nextId('job'),
    title: stringValue(req.body.title) || 'New Job',
    department: stringValue(req.body.department) || 'General',
    description: stringValue(req.body.description) || 'Job description',
    status: 'open',
    openDate: new Date().toISOString(),
    candidateCount: 0,
    assignedCandidateIds: [],
    closedDate: null,
    createdAt: new Date().toISOString(),
  };

  state.jobs.unshift(job);
  addActivity({
    action: 'created job',
    actorName: req.user.name,
    targetName: job.title,
    type: 'jobCreated',
    jobId: job.id,
  });

  return res.status(201).json({
    success: true,
    data: {
      job,
    },
  });
});

router.put('/jobs/:id', (req, res) => {
  const job = findJob(req.params.id);
  if (!job) {
    return notFound(res, 'Job not found.');
  }

  if (req.body.title !== undefined) {
    job.title = stringValue(req.body.title) || job.title;
  }
  if (req.body.department !== undefined) {
    job.department = stringValue(req.body.department) || job.department;
  }
  if (req.body.description !== undefined) {
    job.description = stringValue(req.body.description) || job.description;
  }

  return res.json({
    success: true,
    data: {
      job,
    },
  });
});

router.post('/jobs/:id/toggle', (req, res) => {
  const job = findJob(req.params.id);
  if (!job) {
    return notFound(res, 'Job not found.');
  }

  job.status = job.status === 'open' ? 'closed' : 'open';
  job.closedDate = job.status === 'closed' ? new Date().toISOString() : null;

  return res.json({
    success: true,
    message: `Job marked as ${job.status}.`,
  });
});

router.post('/jobs/:id/assign', (req, res) => {
  const job = findJob(req.params.id);
  const candidate = findCandidate(stringValue(req.body.candidateId));

  if (!job) {
    return notFound(res, 'Job not found.');
  }
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  if (!job.assignedCandidateIds.includes(candidate.id)) {
    job.assignedCandidateIds.push(candidate.id);
    job.candidateCount = job.assignedCandidateIds.length;
  }
  candidate.jobId = job.id;
  candidate.jobTitle = job.title;
  candidate.updatedAt = new Date().toISOString();

  addActivity({
    action: 'assigned candidate to job',
    actorName: req.user.name,
    targetName: candidate.name,
    type: 'jobAssigned',
    candidateId: candidate.id,
    jobId: job.id,
  });
  pushNotification({
    title: 'Candidate assigned to job',
    body: `${candidate.name} was assigned to ${job.title}.`,
    type: 'jobAssigned',
    candidateId: candidate.id,
    jobId: job.id,
  });

  return res.json({
    success: true,
    message: 'Candidate assigned successfully.',
  });
});

router.get('/pipeline/stages', (_req, res) => {
  return res.json({
    success: true,
    data: stageCatalog.map((stage) => ({
      id: stage.id,
      stage: stage.stage,
      name: stage.name,
      candidates: state.candidates
        .filter((candidate) => candidate.currentStage === stage.stage)
        .map((candidate) => ({ ...candidate })),
    })),
  });
});

router.put('/pipeline/candidates/:id/move', (req, res) => {
  const candidate = findCandidate(req.params.id);
  if (!candidate) {
    return notFound(res, 'Candidate not found.');
  }

  const stage = stringValue(req.body.stage);
  const stageInfo = stageCatalog.find((item) => item.stage === stage);
  if (!stageInfo) {
    return res.status(422).json({
      success: false,
      message: 'Invalid stage.',
    });
  }

  candidate.currentStage = stageInfo.stage;
  candidate.updatedAt = new Date().toISOString();
  candidate.stageHistory.unshift({
    id: `history-${Date.now()}`,
    stage: stageInfo.stage,
    movedByName: req.user.name,
    movedAt: new Date().toISOString(),
    note: nullableString(req.body.note),
  });

  addActivity({
    action: `moved candidate to ${stageInfo.name.toLowerCase()}`,
    actorName: req.user.name,
    targetName: candidate.name,
    type: 'stageMoved',
    candidateId: candidate.id,
    jobId: candidate.jobId,
  });
  pushNotification({
    title: 'Candidate stage updated',
    body: `${candidate.name} was moved to ${stageInfo.name}.`,
    type: 'stageMoved',
    candidateId: candidate.id,
    jobId: candidate.jobId,
  });

  return res.json({
    success: true,
    message: 'Candidate moved successfully.',
  });
});

router.put('/pipeline/stages/:id', (req, res) => {
  const stage = stageCatalog.find((item) => item.id === req.params.id);
  if (!stage) {
    return notFound(res, 'Stage not found.');
  }

  stage.name = stringValue(req.body.name) || stage.name;
  return res.json({
    success: true,
    data: {
      stage,
    },
  });
});

router.get('/activity-log', (req, res) => {
  const page = Math.max(Number(req.query.page || 1), 1);
  const limit = Math.max(Number(req.query.limit || 30), 1);
  const start = (page - 1) * limit;
  const end = start + limit;

  return res.json({
    success: true,
    data: {
      activities: state.activities.slice(start, end).map(toActivityResponse),
    },
  });
});

router.get('/notifications', (_req, res) => {
  return res.json({
    success: true,
    data: {
      notifications: state.notifications.map((notification) => ({
        ...notification,
      })),
    },
  });
});

router.put('/notifications/:id/read', (req, res) => {
  const notification = state.notifications.find(
    (item) => item.id === req.params.id
  );
  if (notification) {
    notification.isRead = true;
  }

  return res.json({
    success: true,
    message: 'Notification marked as read.',
  });
});

router.put('/notifications/read-all', (_req, res) => {
  state.notifications.forEach((notification) => {
    notification.isRead = true;
  });

  return res.json({
    success: true,
    message: 'All notifications marked as read.',
  });
});

router.get('/notifications/settings', (_req, res) => {
  return res.json({
    success: true,
    data: {
      settings: {
        ...state.notificationSettings,
      },
    },
  });
});

router.put('/notifications/settings', (req, res) => {
  state.notificationSettings = {
    cvUploadedEmail: toBool(
      req.body.cvUploadedEmail ?? req.body.notify_cv_upload,
      state.notificationSettings.cvUploadedEmail
    ),
    stageMovedEmail: toBool(
      req.body.stageMovedEmail ?? req.body.notify_stage_change,
      state.notificationSettings.stageMovedEmail
    ),
    jobAssignedEmail: toBool(
      req.body.jobAssignedEmail,
      state.notificationSettings.jobAssignedEmail
    ),
    pushEnabled: toBool(
      req.body.pushEnabled,
      state.notificationSettings.pushEnabled
    ),
  };

  return res.json({
    success: true,
    message: 'Notification settings updated.',
    data: {
      settings: {
        ...state.notificationSettings,
      },
    },
  });
});

function successAuthPayload(user) {
  const session = issueSession(user);
  return {
    success: true,
    data: {
      token: session.accessToken,
      refreshToken: session.refreshToken,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        avatar_url: user.avatar_url,
      },
      company: {
        id: state.company.id,
        name: state.company.name,
        slug: state.company.slug,
      },
    },
  };
}

function requireAuth(req, res, next) {
  const header = req.headers.authorization || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : null;
  const userId = token ? state.sessions.get(token) : null;
  const user = state.users.find((item) => item.id === userId);

  if (!token || !user) {
    return res.status(401).json({
      success: false,
      message: 'Authentication required.',
    });
  }

  req.token = token;
  req.user = {
    id: user.id,
    userId: user.id,
    companyId: state.company.id,
    email: user.email,
    name: user.name,
    role: user.role,
  };
  next();
}

function issueSession(user) {
  const accessToken = `mock-access-${user.id}-${nextId('access')}`;
  const refreshToken = `mock-refresh-${user.id}-${nextId('refresh')}`;

  state.sessions.set(accessToken, user.id);
  state.refreshSessions.set(refreshToken, user.id);

  return { accessToken, refreshToken };
}

function revokeAccessToken(accessToken) {
  state.sessions.delete(accessToken);
}

function findCandidate(id) {
  return state.candidates.find((candidate) => candidate.id === id);
}

function findJob(id) {
  return state.jobs.find((job) => job.id === id);
}

function dashboardStats() {
  const stageMap = {
    Applied: 0,
    Shortlisted: 0,
    Interview: 0,
    Hired: 0,
    Rejected: 0,
  };

  state.candidates.forEach((candidate) => {
    const stage = stageCatalog.find((item) => item.stage === candidate.currentStage);
    if (stage) {
      stageMap[stage.name] += 1;
    }
  });

  return {
    totalCandidates: state.candidates.length,
    activeJobs: state.jobs.filter((job) => job.status === 'open').length,
    totalHired: state.candidates.filter(
      (candidate) => candidate.currentStage === 'hired'
    ).length,
    totalRejected: state.candidates.filter(
      (candidate) => candidate.currentStage === 'rejected'
    ).length,
    candidatesPerStage: stageMap,
    recentActivity: state.activities.slice(0, 5).map(toActivityResponse),
  };
}

function teamMembers() {
  return state.users.map((user) => ({
    id: user.id,
    name: user.name,
    email: user.email,
    role: user.role,
    avatarUrl: user.avatar_url,
  }));
}

function addActivity(activity) {
  state.activities.unshift({
    id: nextId('activity'),
    createdAt: new Date().toISOString(),
    candidateId: null,
    jobId: null,
    ...activity,
  });
}

function pushNotification(notification) {
  state.notifications.unshift({
    id: nextId('notification'),
    createdAt: new Date().toISOString(),
    isRead: false,
    candidateId: null,
    jobId: null,
    ...notification,
  });
}

function toActivityResponse(activity) {
  return {
    id: activity.id,
    action: activity.action,
    actorName: activity.actorName,
    targetName: activity.targetName,
    createdAt: activity.createdAt,
    type: activity.type,
  };
}

function nextId(prefix) {
  counters[prefix] = (counters[prefix] || 0) + 1;
  return `${prefix}-${counters[prefix]}`;
}

function stringValue(value) {
  if (value == null) {
    return '';
  }
  return String(value).trim();
}

function normalizeEmail(value) {
  return stringValue(value).toLowerCase();
}

function isValidEmail(value) {
  return /^[^\s@]+@([^\s@.]+\.)+[^\s@.]{2,}$/.test(value);
}

function validationFailed(res, errors) {
  return res.status(422).json({
    success: false,
    message: 'Validation failed.',
    errors,
  });
}

function nullableString(value) {
  const normalized = stringValue(value);
  return normalized || null;
}

function normalizeStringList(value) {
  if (!Array.isArray(value)) {
    return [];
  }

  return value
    .map((item) => stringValue(item))
    .filter(Boolean);
}

function toBool(value, fallback = false) {
  if (typeof value === 'boolean') {
    return value;
  }
  if (typeof value === 'number') {
    return value === 1;
  }
  if (typeof value === 'string') {
    return value.toLowerCase() === 'true' || value === '1';
  }
  return fallback;
}

function slugify(value) {
  return stringValue(value)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '') || 'hireops-demo';
}

function notFound(res, message) {
  return res.status(404).json({
    success: false,
    message,
  });
}

function isoDaysAgo(days) {
  const date = new Date();
  date.setDate(date.getDate() - days);
  return date.toISOString();
}

module.exports = router;
