/// All user-facing strings in one place — no hardcoded strings in UI.
class AppStrings {
  AppStrings._();

  // ── App ─────────────────────────────────────────────────────────────────────
  static const String appName = 'HireOps';
  static const String appTagline = 'Smarter Recruiting, Simpler Pipelines';

  // ── Auth ─────────────────────────────────────────────────────────────────────
  static const String signIn = 'Sign In';
  static const String signUp = 'Sign Up';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String fullName = 'Full Name';
  static const String companyName = 'Company Name';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String sendOtp = 'Send OTP';
  static const String verifyOtp = 'Verify OTP';
  static const String otpSentMessage =
      'A 6-digit code has been sent to your email.';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String passwordMismatch = 'Passwords do not match.';

  // ── Navigation ───────────────────────────────────────────────────────────────
  static const String dashboard = 'Dashboard';
  static const String candidates = 'Candidates';
  static const String jobs = 'Jobs';
  static const String activity = 'Activity';
  static const String settings = 'Settings';

  // ── Dashboard ────────────────────────────────────────────────────────────────
  static const String totalCandidates = 'Total Candidates';
  static const String activeJobs = 'Active Jobs';
  static const String recentActivity = 'Recent Activity';
  static const String quickActions = 'Quick Actions';
  static const String uploadCv = 'Upload CV';
  static const String addJob = 'Add Job';
  static const String viewCandidates = 'View Candidates';
  static const String candidatesPerStage = 'Candidates per Stage';

  // ── Candidates ───────────────────────────────────────────────────────────────
  static const String candidateList = 'Candidates';
  static const String addCandidate = 'Add Candidate';
  static const String editCandidate = 'Edit Candidate';
  static const String candidateProfile = 'Candidate Profile';
  static const String searchCandidates = 'Search candidates…';
  static const String filterBy = 'Filter By';
  static const String tags = 'Tags';
  static const String experience = 'Experience';
  static const String skills = 'Skills';
  static const String notes = 'Notes';
  static const String addNote = 'Add Note';
  static const String editNote = 'Edit Note';
  static const String deleteNote = 'Delete Note';
  static const String noNotes = 'No notes yet. Add one!';
  static const String phone = 'Phone';
  static const String experienceYears = 'Years of Experience';
  static const String currentStage = 'Current Stage';
  static const String stageHistory = 'Stage History';
  static const String previewCv = 'Preview CV';
  static const String downloadCv = 'Download CV';
  static const String noCandidates = 'No candidates found.';

  // ── CV Upload ─────────────────────────────────────────────────────────────────
  static const String uploadYourCv = 'Upload a CV';
  static const String cvUploadSubtitle = 'Supported: PDF, DOC, DOCX · Max 5 MB';
  static const String browseFile = 'Browse File';
  static const String uploading = 'Uploading…';
  static const String cvUploadSuccess = 'CV uploaded successfully!';
  static const String fileTooLarge = 'File exceeds 5 MB limit.';
  static const String invalidFileType = 'Only PDF, DOC, DOCX files allowed.';

  // ── Jobs ─────────────────────────────────────────────────────────────────────
  static const String jobList = 'Job Positions';
  static const String addJobPosition = 'Add Job Position';
  static const String editJob = 'Edit Job';
  static const String jobTitle = 'Job Title';
  static const String department = 'Department';
  static const String description = 'Description';
  static const String status = 'Status';
  static const String open = 'Open';
  static const String closed = 'Closed';
  static const String openDate = 'Open Date';
  static const String assignCandidate = 'Assign Candidate';
  static const String noJobs = 'No job positions yet.';

  // ── Pipeline ──────────────────────────────────────────────────────────────────
  static const String pipeline = 'Hiring Pipeline';
  static const String moveToNextStage = 'Move to Next Stage';
  static const String moveToPrevStage = 'Move to Previous Stage';
  static const String confirmStageMove =
      'Are you sure you want to move this candidate?';

  // ── Pipeline Stages ───────────────────────────────────────────────────────────
  static const String stageApplied = 'Applied';
  static const String stageShortlisted = 'Shortlisted';
  static const String stageInterview = 'Interview';
  static const String stageHired = 'Hired';
  static const String stageRejected = 'Rejected';

  // ── Activity ──────────────────────────────────────────────────────────────────
  static const String activityLog = 'Activity Log';
  static const String noActivity = 'No activity recorded yet.';

  // ── Notifications ─────────────────────────────────────────────────────────────
  static const String notifications = 'Notifications';
  static const String emailNotifications = 'Email Notifications';
  static const String noNotifications = 'You\'re all caught up!';

  // ── Settings ──────────────────────────────────────────────────────────────────
  static const String companyProfile = 'Company Profile';
  static const String pipelineStages = 'Pipeline Stages';
  static const String teamMembers = 'Team Members';
  static const String darkMode = 'Dark Mode';
  static const String saveChanges = 'Save Changes';
  static const String dangerZone = 'Danger Zone';

  // ── Common ────────────────────────────────────────────────────────────────────
  static const String loading = 'Loading…';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String delete = 'Delete';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String add = 'Add';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String apply = 'Apply';
  static const String clear = 'Clear';
  static const String close = 'Close';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String done = 'Done';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String noDataFound = 'No data found.';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String noInternetConnection = 'No internet connection.';
  static const String sessionExpired =
      'Your session has expired. Please log in again.';
  static const String deleteConfirmation =
      'This action cannot be undone. Are you sure?';
  static const String logoutConfirmation = 'Are you sure you want to log out?';
}
