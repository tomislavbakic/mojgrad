// String port = "2041";
// String ip = "http://147.91.204.116";
// String wwwrootURL = ip + ":" + port + "//";
// String url = ip + ":" + port + "/api";

String port = "2039";
 String ip = "http://147.91.204.116";
String wwwrootURL = ip + ":" + port + "//";
String url = ip + ":" + port + "/api";

// //global url
// String url = "http://127.0.0.1:55863/api";
// String wwwrootURL = "http://127.0.0.1:55863//";

String adminURL = url + "/admins";
String adminLoginURL = adminURL + "/login";
String deleteUserURL = adminURL + "/userdelete";
String postURL = url + "/Posts";
String imageUploadURL = url + "/ImageUpload";
String categoryURL = url + "/Categories";
String imageUploadWebURL = imageUploadURL + "/webImageUpload";
String userDatasURL = url + "/UserDatas";

String blockedUsersURL = userDatasURL + "/blockedUsers";
String topEkoUsersURL = userDatasURL + "/topUsers";
String loginURL = userDatasURL + "/login";
String emailURL = userDatasURL + "/email";
String postImageUploadURL = imageUploadURL + "/postImage";
String userProfileImageUploadURL = imageUploadURL + "/userImage";
String feedbackURL = url + "/feedbacks";
String changePasswordURL = userDatasURL + "/changePassword";
String changeUserDataURL = userDatasURL + "/changeUserData";
String userDatasRegistrationURL = userDatasURL + "/register";
String commentURL = url + "/comments";
String postLikeURL = postURL + "/likes";
String commentReactionURL = commentURL + "/likes";
String postReportsURL = url + "/postReport";

String postServerPathImage = "Upload//Posts//";
String userServerPathImage = "Upload//UserProfile//";
String userWhoLikePostURL = url + "/postlike";
String cityURL = url + "/cities";
//get, post methods
String organisationURL = url + "/organisations";
//check user method, generate token
String organisationLoginURL = organisationURL + "/login";
//check email
String organisationCheckURL = organisationURL + "/email";
//verifivation organisation
String verificateOrganisationURL = organisationURL + "/verify";
//post organisation
String organisationPostsURL = url + "/organisationPosts";
//app rate
String rateURL = url + "/rate";
//rank controler url
String ranksURL = url + "/ranks";
//post category info percentage
String percentageURL = postURL + "/categoryinfo";
//post filter cartegory and city
String cityAndCategoryFilterURL = postURL + "/PostsByCityAndCategory";

String addSavedPostURL = postURL + "/addSavedPost"; //post
String deleteSavedPostURL = postURL + "/DeleteSavedPost";
String savedPostsURL = postURL + "/SavedPosts";
String addPostSolutionURL = postURL + "/addPostSolution";
String commentReports = url + "/CommentReports";
//rank uplaod image route
String rankUploadServerRoute = "Upload//Ranks//";
String organisationPostsServerRoute = "Upload//OrganisationPosts//";
String organisationCoverPhotoServerRoute = "Upload//Organisations//";
String solutionServerRoute = "Upload//Solutions//";
