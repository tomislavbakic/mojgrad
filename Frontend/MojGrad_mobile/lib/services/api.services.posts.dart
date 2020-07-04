import 'dart:convert';
import 'dart:io';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/functions/images.dart';
import 'package:fronend/models/category.dart';
import 'package:fronend/models/comment.dart';
import 'package:fronend/models/feedback.dart';
import 'package:fronend/models/post.dart';
import 'package:fronend/models/postSolution.dart';
import 'package:fronend/models/view/changePostModel.dart';
import 'package:fronend/models/view/commentInfo.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/models/view/postOrganisationView.dart';
import 'package:fronend/models/view/postSolutionInfo.dart';
import 'package:fronend/models/view/userLikeList.dart';
import 'package:http/http.dart' as http;

class APIServicesPosts {
  static Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
//fetch all post from database
  static Future<List<Post>> fetchAllPosts(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = postURL + "/userid=" + LoggedUser.id.toString();
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<Post> postList = new List<Post>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        postList.add(Post.fromObject(post));
      }
      return postList;
    }
    return null;
  }

  static Future<List<PostInfo>> fetchAllActivePosts(
      String jwt, int cityID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = postURL + "/activePosts/" + LoggedUser.id.toString();
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostInfo> activePostList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        activePostList.add(PostInfo.fromObject(post));
      }
      return activePostList;
    }
    return null;
  }

  //function returns all posts and info does posts liked by USERID
  //isLiked: 1   user liked post
  //isLiked: 0   user not liked post
  static Future<List<Post>> fetchAllPostsByUserID(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = postURL + "/userid=" + LoggedUser.id.toString();
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<Post> postList = new List<Post>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        postList.add(Post.fromObject(post));
      }
      return postList;
    }
    return null;
  }

  //add new post in database
  static Future<bool> addPost(String jwt, Post post) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var myPost = post.toMap();
    var postBody = json.encode(myPost);
    var res = await http.post(postURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: postBody);
    // print(res.statusCode);
    // print(res.body);
    // print(postBody);
    return Future.value(res.statusCode == 201 ? true : false);
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

  //function for posts report
  static Future<bool> reportPost(
      String jwt, String description, int postID, int userDataId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['description'] = description;
    map['postID'] = postID;
    map['userDataID'] = userDataId;
    var postBody = json.encode(map);
    var res = await http.post(postReportURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: postBody);
    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  //function update post data, image, title and description
  static Future<bool> updatePostData(
      String jwt, ChangePostModel post, File image, String fileName) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var putBody = jsonEncode(post.toMap());
    if (image != null)
      await uploadImageNew(image, postImageUploadURL, fileName);
    var res = await http.put(changePostDataURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: putBody);
    if (res.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  //function returns all users who likes posts in list of users
  static Future<List<UserLike>> getUsersWhoLikedPost(
      String jwt, int idPost) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var res = await http.get(userWhoLikePostURL + "/$idPost", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<UserLike> userList = new List<UserLike>();
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      for (var item in data) {
        userList.add(UserLike.fromObject(item));
      }
      return userList;
    }
    return null;
  }

  //function make new like reaction on post, seccond call make unlike
  static Future<bool> likePost(String jwt, int postID, int userID) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var data = Map();
    data['postID'] = postID;
    data['userDataID'] = userID;
    var jsonBody = jsonEncode(data);
    var res = await http.post(postLikeURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);
    String x = jsonDecode(res.body);
    if (x == "Like added" || x == "Like removed")
      return true;
    else
      return false;
  }

  //function add new feedback to database
  static Future<bool> addFeedback(String jwt, Feedbacks feed) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();

    var myFeedback = feed.toMap();
    var feedBody = json.encode(myFeedback);
    var res = await http.post(feedbackURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: feedBody);
    print(res.statusCode);
    return Future.value(res.statusCode == 200 ? true : false);
  }

  //function add new comment in database and upload image file to server
  static Future<bool> addNewComment(
      String jwt, Comment c, File image, fileName) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    String url = commentURL;
    var myComment = c.toMap();
    var jsonBody = json.encode(myComment);
    if (image != null) {
      await uploadImageNew(image, commentImageUploadURL, fileName);
    }
    var res = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  //function record new comment reaction
  // reaction = -1  --> dislike
  // reaction = 0   --> no reaction
  // reaction = 1   --> like
  static Future<String> commentReaction(
      String jwt, int commentID, int userID, int reaction) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var data = Map();
    data['commentID'] = commentID;
    data['userDataID'] = userID;
    data['likeOrDislike'] = reaction; //moze da bude -1 ili 1
    var jsonBody = jsonEncode(data);
    var res = await http.post(commentReactionURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);
    return res.body;
  }

  //function returns list of comments for post by post ID
  static Future<List<CommentView>> getCommentsByPostID(
      String jwt, int postID) async {
    String url =
        postURL + "/$postID/comments/userid=" + LoggedUser.id.toString();
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<CommentView> commentList = new List<CommentView>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        commentList.add(CommentView.fromObject(post));
      }
      return commentList;
    }
    return null;
  }

  //function return post by user id
  static Future<List<PostInfo>> getAllUsersPostsByUserID(
      String jwt, int id) async {
    String url = postURL +
        "/byUser/" +
        id.toString() +
        "/userid=" +
        LoggedUser.id.toString();
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

  static Future<List<PostInfo>> fetchAllPostsInfos(
      String jwt, int cityID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url =
        postURL + "/city/$cityID" + "/userid=" + LoggedUser.id.toString();
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

  //fetch post by user id from logged user id angle
  static Future<PostInfo> fetchPostByID(String jwt, int id) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    String url = postURL + "/$id" + "/userid=" + LoggedUser.id.toString();
    http.Response response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
      var datas = jsonDecode(response.body);
      PostInfo post = new PostInfo.fromObject(datas);
      return post;
    }
    return null;
  }

  //function for comment report
  static Future<bool> reportComment(
      String jwt, String description, int commentID, int userDataId) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['description'] = description;
    map['commentID'] = commentID;
    map['userDataID'] = userDataId;
    var postBody = json.encode(map);
    var res = await http.post(commentReportURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: postBody);

    if (res.statusCode == 200)
      return true;
    else
      return false;
  }

  //function delete comment by comment id
  static Future<int> deleteCommentByID(String jwt, int commentID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await http.delete(commentURL + "/$commentID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt'
    });
    return (res.statusCode);
  }

  static Future<bool> closeChallange(String jwt, int postID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var res = await http.post(
      closeChallangeURL + "/$postID",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt'
      },
    );

    if (res.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  static Future<List<PostInfo>> getFilteredPosts(
      String jwt,
      List<Category> category,
      int cityID,
      int isActive,
      int pageIndex,
      int pageSize) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    List<Map<String, dynamic>> data2 = List<Map<String, dynamic>>();
    for (var cat in category) {
      data2.add(cat.toMap());
    }
    var jsonBody = jsonEncode(data2);
    // print(postURL +
    //     "/cityCategoryFilter/${LoggedUser.id.toString()}/city=$cityID/active=$isActive/pageIndex=$pageIndex/pageSize=$pageSize");
    http.Response response = await http.post(
      postURL +
          "/cityCategoryFilter/${LoggedUser.id.toString()}/city=$cityID/active=$isActive/pageIndex=$pageIndex/pageSize=$pageSize",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: jsonBody,
    );
    List<PostInfo> filterPostList = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        filterPostList.add(PostInfo.fromObject(post));
      }
      return filterPostList;
    }
    return null;
  }

  static Future<List<PostInfo>> getBeautyPosts(String jwt, int cityID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response = await http.get(
      postURL + "/beautifulPosts/${LoggedUser.id.toString()}/city=$cityID",
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
    );
    List<PostInfo> beauty = new List<PostInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        beauty.add(PostInfo.fromObject(post));
      }
      return beauty;
    }
    return null;
  }

  static Future<bool> addPostSolution(
      String jwt, PostSolution ps, File image,fileName) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var postBody = jsonEncode(ps.toMap());
    uploadImageNew(image, solutionImageUploadURL,fileName);
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

  static Future<List<PostSolutionInfo>> getAllSolutionByPostID(
      String jwt, int postID, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    // print("SALJE SE REQUEST");
    // print(postURL + "/PostSolutions/$postID/userid=$userID");
    http.Response response = await http
        .get(postURL + "/PostSolutions/$postID/userid=$userID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    // print("POSLE REQUESTA");
    // print(response.statusCode);
    // print(response.body);
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

//return awarded comment where AWARDED = 1 for user with userID
  static Future<List<PostSolutionInfo>> getAwardedSolutionsForUser(
      String jwt, int userID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    http.Response response =
        await http.get(postURL + "/awardedSolutions/$userID", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });
    List<PostSolutionInfo> solutionList = new List<PostSolutionInfo>();
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var post in data) {
        solutionList.add(PostSolutionInfo.fromObject(post));
      }
      return solutionList;
    }
    return null;
  }

  static Future<void> rewardUser(String jwt, int solutionID) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();
    var map = Map();
    map['solutionID'] = solutionID;
    map['prize'] = 10;
    var putBody = json.encode(map);
    var res = await http.post(rewardUserURL,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt'
        },
        body: putBody);
  }

  static Future<List<PostOrgView>> getAllOrganisationsPosts(String jwt) async {
    var data = jsonDecode(jwt);
    jwt = data['token'].toString();

    http.Response response = await http
        .get(organisationPostsURL + "/userid=${LoggedUser.id}", headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $jwt',
    });

    List<PostOrgView> list = new List<PostOrgView>();
    print(response.statusCode);
    print("dadsdadasdasddsdsa");
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var item in data) {
        list.add(PostOrgView.fromObject(item));
        print("dasdsa");
      }
      return list;
    }
    return null;
  }

  //function record new comment reaction
  // reaction = -1  --> dislike
  // reaction = 0   --> no reaction
  // reaction = 1   --> like
  static Future<String> solutionReaction(
      String jwt, int solutionID, int userID, int reaction) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var data = Map();
    data['postSolutionID'] = solutionID;
    data['userDataID'] = userID;
    data['likeOrDislike'] = reaction; //moze da bude -1 ili 1
    var jsonBody = jsonEncode(data);
    var res = await http.post(postURL + "/SolutionLikes",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);
    return res.body;
  }

  //function record new post org reaction
  // reaction = -1  --> dislike
  // reaction = 0   --> no reaction
  // reaction = 1   --> like
  static Future<String> orgPostReaction(
      String jwt, int orgPostID, int userID, int reaction) async {
    var token = jsonDecode(jwt);
    jwt = token['token'].toString();
    var data = Map();
    data['organisationPostID'] = orgPostID;
    data['userDataID'] = userID;
    data['likeOrDislike'] = reaction; //moze da bude -1 ili 1
    var jsonBody = jsonEncode(data);
    var res = await http.post(organisationPostsURL + "/likes",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $jwt',
        },
        body: jsonBody);
    return res.body;
  }
}
