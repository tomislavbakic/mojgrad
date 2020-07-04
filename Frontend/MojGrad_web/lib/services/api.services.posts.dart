import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:webproject/config/configuration.dart';
import 'package:webproject/models/postSolution.dart';
import 'package:webproject/models/savedPost.dart';
import 'package:webproject/models/view/postInfo.dart';
import 'package:webproject/models/view/postSolutionInfo.dart';
import 'package:webproject/models/view/reportedComment.dart';

class APIServicesPosts {
  static Future<List<PostInfo>> fetchAllPostsInfos(
      String jwt, String url) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostInfo> postList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        postList.add(PostInfo.fromObject(post));
      }
      return postList;
    }
    return null;
  }

  static Future<PostInfo> fetchPostByID(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = postURL + "/$id";
    Response response = await get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    if (response.statusCode == 200) {
      var datas = jsonDecode(response.body);
      PostInfo post = new PostInfo.fromObject(datas);
      return post;
    }
    return null;
  }

  static Future<List<PostInfo>> fetchAllReportedPosts(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    Response response = await get(postReportsURL, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    List<PostInfo> reportedPostsList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        reportedPostsList.add(PostInfo.fromObject(item));
      }
      return reportedPostsList;
    }
    return null;
  }

  //function delete post by post id
  static Future<void> deletePostByID(String jwt, int postID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await http.delete(postURL + "/$postID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  //function return post by user id
  static Future<List<PostInfo>> getAllUsersPostsByUserID(
      String jwt, int id) async {
    String url = postURL + "/byUser/" + id.toString() + "/userid=1";
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostInfo> postList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        postList.add(PostInfo.fromObject(post));
      }
      return postList;
    }
    return null;
  }

  static Future<List<PostSolutionInfo>> getAllSolutionByPostID(
      String jwt, int postID, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response = await http
        .get(postURL + "/postSolutions" + "/$postID/userid=1", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    List<PostSolutionInfo> solutionsList = new List<PostSolutionInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        solutionsList.add(PostSolutionInfo.fromObject(item));
      }
      return solutionsList;
    }
    return null;
  }

  static Future<bool> deleteSolutionBySolutionID(
      String jwt, int solutionID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response =
        await http.delete(postURL + "/postSolutions/$solutionID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<PostInfo>> getAllPostsByFilter(
      String jwt,int userID, int cityID, int categoryID, int type) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url =
        cityAndCategoryFilterURL + "/userID=$userID/category=$categoryID/city=$cityID/$type";

    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostInfo> reportedPostsList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        reportedPostsList.add(PostInfo.fromObject(item));
      }
      return reportedPostsList;
    }
    return null;
  }

  static Future<bool> addSavedPost(String jwt, int orgID, int postID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    SavedPost sp = SavedPost(orgID, postID);
    var postBody = jsonEncode(sp.toMap());
    http.Response response = await http.post(addSavedPostURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);

    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteSavedPost(String jwt, int orgID, int postID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response = await http
        .delete(deleteSavedPostURL + "/post=$postID/org=$orgID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<PostInfo>> getAllSavedPostsByOrgID(
      String jwt, int orgID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response =
        await http.get(savedPostsURL + "/$orgID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostInfo> savedPostsList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        savedPostsList.add(PostInfo.fromObject(item));
      }
      return savedPostsList;
    }
    return null;
  }

  static Future<bool> addPostSolution(String jwt, PostSolution ps) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    var postBody = jsonEncode(ps.toMap());
    http.Response response = await http.post(addPostSolutionURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);

    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> likeSolution(
      String jwt, int solutionID, int userID, int likeOrDislike) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['solutionID'] = solutionID;
    map['userDataID'] = userID;
    map['likeOrDislike'] = likeOrDislike;
    var postBody = jsonEncode(map);
    http.Response response = await http.post(postURL + "/SolutionLikes",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: postBody);
  }

  static Future<List<ReportedCommentView>> getAllReportedComment(
      String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    Response response = await get(commentReports, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<ReportedCommentView> reportedComments = List<ReportedCommentView>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        reportedComments.add(ReportedCommentView.fromObject(item));
      }
      return reportedComments;
    }
    return null;
  }

  //function delete comment by post id
  static Future<void> deleteCommentByID(String jwt, int commentID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await http.delete(commentURL + "/$commentID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }

  static Future<void> deleteOrgPostByID(String jwt, int postID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await http.delete(organisationPostsURL + "/$postID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
  }
}
