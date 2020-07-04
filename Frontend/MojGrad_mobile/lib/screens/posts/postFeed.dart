import 'package:flutter/material.dart';
import 'package:fronend/config/config.dart';
import 'package:fronend/config/loggedUserData.dart';
import 'package:fronend/models/category.dart';
import 'package:fronend/models/view/postInfo.dart';
import 'package:fronend/screens/posts/commentPage.dart';
import 'package:fronend/screens/posts/showPosts.dart';
import 'package:fronend/services/api.services.posts.dart';
import '../../main.dart';
import 'package:carousel_slider/carousel_slider.dart';



class PostFeed extends StatefulWidget {
  int page = 0;
  List<Category> category = List<Category>();
  List<PostInfo> imgList = List<PostInfo>();
  int cityID = LoggedUser.data.cityID;
  PostFeed({this.page, this.category, this.imgList, this.cityID});
  @override
  _PostFeedState createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  CarouselSlider carouselSlider;
  int _currentPage = 0;
  int _current;

  List<PostInfo> allPosts = List<PostInfo>();
  ScrollController _scrollController = new ScrollController();

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    fetchPosts();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchPosts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  fetchPosts() {
    widget.page == 0
        ? APIServicesPosts.getFilteredPosts(globalJWT, widget.category,
                widget.cityID, ALL_POSTS, _currentPage, PAGE_SIZE)
            .then((value) {
            if (!mounted) return;
            setState(() {
              allPosts.addAll(value);
              _currentPage = _currentPage + 1;
            });
          })
        //active posts page
        : APIServicesPosts.getFilteredPosts(globalJWT, widget.category,
                widget.cityID, ACTIVE_POSTS, _currentPage, PAGE_SIZE)
            .then((value) {
            if (!mounted) return;
            setState(() {
              allPosts.addAll(value);
              _currentPage = _currentPage + 1;
            });
          });
  }

  String reportText;
  var rating = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
 
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            buildBeautifulPosts(),
            SizedBox(height: 10.0),
            allPosts.length > 0
                ? ShowPosts(allPosts)
                : Center(child: Text("Trenutno nema objava.")),
          ],
        ),
      ),
    );
  }

  Widget buildBeautifulPosts() {
    if (widget.imgList.length == 0) return Container();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        carouselSlider = CarouselSlider(
          height: 170.0,
          initialPage: 0,
          enlargeCenterPage: true,
          autoPlay: true,
          reverse: false,
          enableInfiniteScroll: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 2500),
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            _current = index;
          },
          items: widget.imgList.map(
            (imgUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                   
                      child: Stack(children: <Widget>[
                        GestureDetector(
                          onDoubleTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentPage(imgUrl.id),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              wwwrootURL + imgUrl.postImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 0.0,
                          bottom: 0.0,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            color: Colors.black.withOpacity(0.4),
                            height: 40,
                            child: new Text(imgUrl.title,
                                style: new TextStyle(
                                    fontSize: 15.0, color: Colors.white)),
                          ),
                        ),
                      ]));
                },
              );
            },
          ).toList(),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

 

}
