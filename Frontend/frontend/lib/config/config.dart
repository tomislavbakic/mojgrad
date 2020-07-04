//server port
import 'package:flutter/material.dart';

//server ip
String port = "2039";
String ip = "http://147.91.204.116";
String url = ip + ":" + port + "/api";
String wwwrootURL = ip + ":" + port  +"//";

// //server ip
// String port = "2039";
// String ip = "http://147.91.204.116";
// String url = ip + ":" + port + "/api";
// String wwwrootURL = ip + ":" + port  +"//";

// String wwwrootURL = "http://10.0.2.2:55863//";

// //global url
// String url = "http://10.0.2.2:55863/api";
//route for post api/posts
String postURL = url + "/Posts";
//String postUserIdURL = postURL + "/userid=";

//route for image upload on server ImageUploadController
String imageUploadURL = url + "/ImageUpload";
//route on ImageUploadController for post image
String postImageUploadURL = imageUploadURL + "/postImage";
//route on ImageUploadController for user profile image
String userProfileImageUploadURL = imageUploadURL + "/userImage";
//route on ImageUploadController for comment image
String commentImageUploadURL = imageUploadURL + "/commentsImage";

String solutionImageUploadURL = imageUploadURL + "/solutions";
//route for categories on CategoryController
String categoryURL = url + "/Categories";
//route for feedbacks on FeedbackController
String feedbackURL = url + "/feedbacks";
//default route on UserDataControler
String userDatasURL = url + "/userDatas";
//user login route on UserDataControler
String loginURL = userDatasURL + "/login";
//route for check email on UserDataController
String emailURL = userDatasURL + "/email";
//route for change user password
String changePasswordURL = userDatasURL + "/changePassword";
//route for change user email,name, lastname
String changeUserDataURL = userDatasURL + "/changeUserData";
//route for change user profile image in database
String changeUserProfileImgURL = userDatasURL + "/changeUserProfileImg";
//route for register new user - userdata controller
String userDatasRegistrationURL = userDatasURL + "/register";
//default route on CommentsController
String commentURL = url + "/comments";
//default route on PostReprotController
String postReportURL = url + "/postReport";
//route on PostControler for LIKE or UNLIKE some posts
String postLikeURL = postURL + "/likes";
//route on CommentControlers for LIKE or DISLIKE comments
String commentReactionURL = commentURL + "/likes";
//route on server userWhoLikePostURl + /postID return who liked post with postID
String userWhoLikePostURL = url + "/postlike";
//route for change post data
String changePostDataURL = postURL + "/changePost";
//route for userReport
String userReportURL = url + "/userreports";
//route for comment reports
String commentReportURL = url + "/CommentReports";
//reward user URL give user prise point
String rewardUserURL = userDatasURL + "/reward";
////close chalange
String closeChallangeURL = postURL + "/closeChallange";

String addSavedPostURL = postURL + "/addSavedPost"; //post
String deleteSavedPostURL = postURL + "/DeleteSavedPost";
String savedPostsURL = postURL + "/SavedPosts";
String addPostSolutionURL = postURL + "/addPostSolution";

String notificationURL = postURL + "/AllNotifications";
//rate my app url
String rateMyAppURL = userDatasURL + "/addRating";
//city
String cityURL = url + "/cities";
//organisation post
String organisationPostsURL = url + "/organisationPosts";
String resetPasswordURL = userDatasURL + "/resetPassword";
String topEkoUsersURL = userDatasURL + "/topUsers";
//String userProfilePhotoURL = "http://10.0.2.2:55863//Upload//UserProfile//";

String postServerPathImage = "Upload//Posts//";
String userServerPathImage = "Upload//UserProfile//";
String commentServerPathImage = "Upload//Comments//";
String postSolutionPathImage = "Upload//Solutions//";


//colors
Color BOJA = Colors.green;

//for post filter
int ACTIVE_POSTS = 1;
int ALL_POSTS = 0;

int PAGE_SIZE = 5;

bool isCheckedDark = false;

final darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  backgroundColor: Colors.blueGrey[300],
  accentColor: Colors.white,
  accentIconTheme: IconThemeData(color: Colors.black),
  dividerColor: Colors.grey,
);

final lightTheme = ThemeData(
  primarySwatch: Colors.green,
  primaryColor: Colors.green,
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFE5E5E5),
  accentColor: Colors.green,
  accentIconTheme: IconThemeData(color: Colors.grey),
  dividerColor: Colors.grey,
);

enum ThemeType { Light, Dark }

class ThemeModel extends ChangeNotifier {
  ThemeData currentTheme = lightTheme;
  ThemeType _themeType = ThemeType.Light;

  toggleTheme() {
    if (_themeType == ThemeType.Dark) {
      isCheckedDark = false;
      currentTheme = lightTheme;
      _themeType = ThemeType.Light;
      return notifyListeners();
    }

    if (_themeType == ThemeType.Light) {
      isCheckedDark = true;
      currentTheme = darkTheme;
      _themeType = ThemeType.Dark;
      return notifyListeners();
    }
  }
}