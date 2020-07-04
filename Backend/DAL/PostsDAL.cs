using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Functions;

namespace Backend.DAL
{
    public class PostsDAL : IPostsDAL
    {
        private readonly DataContext _context;

        public PostsDAL(DataContext context)
        {
            _context = context;
        }

        public async Task<ActionResult<string>> DeletePost(int id)
        {
            try
            {
                var post = await _context.Posts.FirstOrDefaultAsync(x => x.ID == id);

                if (post.PostImage != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(post.PostImage);
                }

                _context.Posts.Remove(post);

                var notify = _context.Notifications.Where(x => x.NotificationForID == id);
                foreach (var item in notify)
                {
                    _context.Notifications.Remove(item);
                }

                await _context.SaveChangesAsync();
                return "Post deleted";
            }
            catch (Exception e)
            {
                return "Failed to delete post with that id";
            } 
        }

        public async Task<ActionResult<bool>> EditPost(ChangePost changePost)
        {
            var post = await _context.Posts.FirstOrDefaultAsync(x => x.ID == changePost.ID);

            if(post == null)
            {
                return false;
            }
            else
            {
                try
                {
                    if (post.PostImage != null && changePost.imageURL != null && changePost.imageURL != post.PostImage)
                    {
                        ImageDelete imgDelete = new ImageDelete();
                        imgDelete.ImageDeleteURL(post.PostImage);
                        
                    }
                    if(changePost.imageURL != null)
                    {
                        post.PostImage = changePost.imageURL;
                    }

                    if(changePost.Title != null)
                    {
                        post.Title = changePost.Title;
                    }

                    if (changePost.Description != null)
                    {

                        post.Description = changePost.Description;
                    }
                    

                    _context.Posts.Update(post);

                    _context.SaveChanges();

                    return true;
                }
                catch (Exception e)
                {

                    return false;
                }
                
            }
        }

        public async Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComents(int id,int userID)
        {
            var comments = await _context.Comments.Where(x => x.PostID == id).Include(x => x.UserData).Include(x => x.Post).Include(x => x.CommentLikes).ToListAsync();

            List<CommentInfo> listComments = new List<CommentInfo>();
            foreach (var item in comments)
            {
                CommentInfo singleCommentInfo = new CommentInfo();
                singleCommentInfo.ID = item.ID;
                singleCommentInfo.FullName = item.UserData.Name + " " + item.UserData.Lastname;
                singleCommentInfo.Text = item.Text;
                singleCommentInfo.LikesNumber = item.CommentLikes.Count(x => x.CommentID == item.ID && x.LikeOrDislike == 1);
                singleCommentInfo.DislikesNumber = item.CommentLikes.Count(x => x.CommentID == item.ID && x.LikeOrDislike == -1);
                singleCommentInfo.UserPhoto = item.UserData.Photo;
                singleCommentInfo.CommentPhoto = item.CommentPhoto;
                singleCommentInfo.UserDataID = item.UserDataID;
                singleCommentInfo.Awarded = item.Awarded;
                singleCommentInfo.PostID = item.PostID;
                singleCommentInfo.PostActive = item.Post.Active;
                var isItLikedOrDisliked = _context.CommentLikes.FirstOrDefault(x => x.CommentID == item.ID && x.UserDataID == userID);
                if (isItLikedOrDisliked == null)
                    singleCommentInfo.isLikedOrDisliked = 0;
                else
                {
                    singleCommentInfo.isLikedOrDisliked = isItLikedOrDisliked.LikeOrDislike;
                }

                listComments.Add(singleCommentInfo);
            }

            return listComments;



        }

        public async Task<ActionResult<IEnumerable<Post>>> GetAllPostsAsync()
        {
            return await _context.Posts.ToListAsync();
        }

        public async Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfo(int userID)
        {
            var posts = await _context.Posts.Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToListAsync();
            return GetAllPostInfoFunction(userID, posts);

        }

        public async Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoByUser(int id, int userID)
        {
            var posts = await _context.Posts.Where(x => x.UserDataID == id).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToListAsync();
            return GetAllPostInfoFunction(userID, posts);
        }

        private List<PostInfo> GetAllPostInfoFunction(int userID, List<Post> posts)
        {
            List<PostInfo> listPostsInfo = new List<PostInfo>();

            foreach (var item in posts)
            {
                PostInfo postInfo = new PostInfo();

                postInfo.ID = item.ID;
                postInfo.Title = item.Title;
                postInfo.Description = item.Description;
                postInfo.Time = item.Time;
                postInfo.Active = item.Active;
                postInfo.FullName = item.UserData.Name + " " + item.UserData.Lastname;
                postInfo.CategoryName = item.Category.Name;
                postInfo.CommentsNumber = _context.Comments.Count(x => x.PostID == item.ID) + _context.PostSolutions.Count(x => x.PostID == item.ID);
                postInfo.LikesNumber = _context.PostLikes.Count(x => x.PostID == item.ID);
                postInfo.UserPhoto = item.UserData.Photo;
                postInfo.PostImage = item.PostImage;
                postInfo.UserID = item.UserData.ID;
                postInfo.Address = item.Location.Address;
                postInfo.City = item.City.Name;
                postInfo.Latitude = item.Location.Latitude;
                postInfo.Longitude = item.Location.Longitude;
                postInfo.Ago = RelativeDate(Convert.ToDateTime(item.Time));

                var isItLiked = _context.PostLikes.FirstOrDefault(x => x.PostID == item.ID && x.UserDataID == userID);
                if (isItLiked == null)
                    postInfo.isLiked = 0;
                else
                    postInfo.isLiked = 1;

                var isItSaved = _context.SavedPosts.FirstOrDefault(x => x.OrganisationID == userID && x.PostID == item.ID);
                if (isItSaved == null)
                    postInfo.isSaved = 0;
                else
                    postInfo.isSaved = 1;

                listPostsInfo.Add(postInfo);
            }
            listPostsInfo.Reverse();
            return listPostsInfo;
        }

        public async Task<ActionResult<PostInfo>> GetPost(int id,int userID)
        {
            var item = await _context.Posts.Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).FirstOrDefaultAsync(x => x.ID == id);

            PostInfo postInfo = new PostInfo();

            if(item == null)
            {
                return null;
            }

            postInfo.ID = item.ID;
            postInfo.Title = item.Title;
            postInfo.Description = item.Description;
            postInfo.Time = item.Time;
            postInfo.Active = item.Active;
            postInfo.FullName = item.UserData.Name + " " + item.UserData.Lastname;
            postInfo.CategoryName = item.Category.Name;
            postInfo.CommentsNumber = _context.Comments.Count(x => x.PostID == item.ID) + _context.PostSolutions.Count(x => x.PostID == item.ID);
            postInfo.LikesNumber = _context.PostLikes.Count(x => x.PostID == item.ID);
            postInfo.UserPhoto = item.UserData.Photo;
            postInfo.PostImage = item.PostImage;
            postInfo.UserID = item.UserData.ID;
            postInfo.Address = item.Location.Address;
            postInfo.City = item.City.Name;
            postInfo.Latitude = item.Location.Latitude;
            postInfo.Longitude = item.Location.Longitude;
            postInfo.Ago = RelativeDate(Convert.ToDateTime(item.Time));

            var isItLiked = _context.PostLikes.FirstOrDefault(x => x.PostID == item.ID && x.UserDataID == userID);
            if (isItLiked == null)
                postInfo.isLiked = 0;
            else
                postInfo.isLiked = 1;

            var isItSaved = _context.SavedPosts.FirstOrDefault(x => x.OrganisationID == userID && x.PostID == item.ID);
            if (isItSaved == null)
                postInfo.isSaved = 0;
            else
                postInfo.isSaved = 1;

            return postInfo;
        }

        public ActionResult<string> PostLike(PostLike postLike)
        {
            var existingLike = _context.PostLikes.FirstOrDefault(x => x.PostID == postLike.PostID && x.UserDataID == postLike.UserDataID);

            if(existingLike == null)
            {
                

                try
                {
                    _context.PostLikes.Add(postLike);
                    _context.SaveChanges();

                    Notification notify = new Notification();
                    var postL = _context.PostLikes.Include(x => x.Post).Include(x => x.UserData).FirstOrDefault(x => x.ID == postLike.ID);

                    var existingNotification = _context.Notifications.FirstOrDefault(x => x.TypeOfNotification == 2 && x.NewThingID == postL.ID && x.UserID == postL.UserDataID);

                    notify.UserID = postL.Post.UserDataID;
                    notify.TypeOfNotification = 2; //newPostLike = 2
                    notify.isRead = false;
                    notify.Title = postL.UserData.Name + " " + postL.UserData.Lastname + " se sviđa Vaša objava " + postL.Post.Title;
                    //notify.Message = postL.UserData.Name + " " + postL.UserData.Lastname + " se svidja tvoja objava " + postL.Post.Title;
                    notify.Message = DateTime.Now.ToString();
                    notify.UserNotificationMakerID = postL.UserDataID;
                    notify.NewThingID = postL.ID;
                    notify.NotificationForID = postL.Post.ID;
                    notify.UserNotificationMakerPhoto = postL.UserData.Photo;


                    if(notify.UserID != notify.UserNotificationMakerID)
                    {
                        _context.Notifications.Add(notify);
                        _context.SaveChanges();
                    }
                    


                    return "Like added";
                }
                catch (Exception e)
                {

                    return "Wrong postID or UserID";
                }
            }
            else
            {
                try
                {
                    

                    var notify = _context.Notifications.FirstOrDefault(x => x.NewThingID == existingLike.ID && x.TypeOfNotification == 2);
                    _context.PostLikes.Remove(existingLike);
                    if(notify != null)
                    { 
                        _context.Notifications.Remove(notify);
                    }

                    _context.SaveChanges();

                    return "Like removed";
                }
                catch (Exception e)
                {

                    return "Wrong postID or UserID for delete";
                }
                
            }
        }

        public async Task SavePostAndLocation(AddPostAndLocation apal)
        {
            Location loc = new Location();
            loc.Address = apal.Address;
            loc.Latitude = apal.Latitude;
            loc.Longitude = apal.Longitude;

            var LocationExists = _context.Location.FirstOrDefault(x => x.Address == loc.Address && x.Latitude == loc.Latitude && x.Longitude == loc.Longitude);
            Post post = new Post();

            if (LocationExists == null)
            {
                _context.Location.Add(loc);
                await _context.SaveChangesAsync();

                post.LocationID = loc.ID;
            }
            else
            {
                post.LocationID = LocationExists.ID;
            }

            
            post.Title = apal.Title;
            post.Description = apal.Description;
            post.Time = apal.Time;
            post.Active = apal.Active;
            post.PostImage = apal.PostImage;
            post.UserDataID = apal.UserDataID;
            post.CategoryID = apal.CategoryID;
            
            post.CityID = apal.CityID;

            _context.Posts.Add(post);
            await _context.SaveChangesAsync();
        }

        public async Task SavePostAsync(Post post)
        {
            _context.Posts.Add(post);
            await _context.SaveChangesAsync();
        }

        public async Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCategory(int id, int userID)
        {

            var posts = await _context.Posts.Where(x => x.CategoryID == id).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToListAsync();
            return GetAllPostInfoFunction(userID, posts);
        }

        public async Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCity(int id, int userID)
        {
            var posts = await _context.Posts.Where(x => x.CityID == id).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToListAsync();
            return GetAllPostInfoFunction(userID, posts);
        }

        public List<CategoryInfo> GetPercentageOfPostsByCategory()
        {
            var groups = _context.Posts.GroupBy(x => x.CategoryID).Select(group => new {
                id = group.Key,
                Count = group.Count()
            });

            var numberOfPosts = _context.Posts.Count();
            List<CategoryInfo> ListCi = new List<CategoryInfo>();

            foreach (var item in groups)
            {
                CategoryInfo ci = new CategoryInfo();
                if (item.Count > 0)
                {
                    ci.CategoryID = item.id;
                    ci.NumberOfPosts = item.Count;
                    ci.CategoryName = _context.Categories.FirstOrDefault(x => x.ID == item.id).Name;
                    
                    double procenta = ((item.Count * 1.0) / (numberOfPosts*1.0)) * 100;
                    //ci.PercentageOfAllPosts = Math.Round(procenta, 2) + "%";
                    ci.PercentageOfAllPosts = procenta.ToString($"F{1}");
                    ListCi.Add(ci);
                    
                }
            }
            var cat = _context.Categories;
            foreach (var item in cat)
            {
                var pom = ListCi.FirstOrDefault(x => x.CategoryID == item.ID);
                if(pom == null)
                {
                    CategoryInfo ci = new CategoryInfo();
                    ci.CategoryID = item.ID;
                    ci.NumberOfPosts = 0;
                    ci.CategoryName = item.Name;
                    ci.PercentageOfAllPosts = 0.ToString();
                    ListCi.Add(ci);
                }
            }

            return ListCi;
        }

        public string CloseChallange(int id)
        {
            Post post = _context.Posts.Where(x => x.ID.Equals(id)).FirstOrDefault();

            post.Active = 0; //no more active
            _context.Posts.Update(post);
            _context.SaveChanges();
            return "true";
        }

        public List<PostSolutionInfo> GetAwardedSolutionByUserID(int userID)
        {
            var solutions = _context.PostSolutions.Where(x => x.UserID == userID && x.isAwarded == 1).Include(x => x.Post).Include(x => x.SolutionLikes).ToList();

            List<PostSolutionInfo> listSolutions = new List<PostSolutionInfo>();
            foreach (var item in solutions)
            {
                PostSolutionInfo singleSPostSolutionInfo = new PostSolutionInfo();
                singleSPostSolutionInfo.ID = item.ID;

                //user 1, org 2
                if (item.UserType == 1)
                {
                    var user = _context.UserDatas.FirstOrDefault(x => x.ID == item.UserID);
                    singleSPostSolutionInfo.FullName = user.Name + " " + user.Lastname;
                    singleSPostSolutionInfo.UserPhoto = user.Photo;
                }
                else if (item.UserType == 2)
                {
                    var org = _context.Organisations.FirstOrDefault(x => x.ID == item.UserID);
                    singleSPostSolutionInfo.FullName = org.Name;
                    singleSPostSolutionInfo.UserPhoto = org.ImagePath;
                }

                singleSPostSolutionInfo.Text = item.Text;
                singleSPostSolutionInfo.LikesNumber = item.SolutionLikes.Count(x => x.PostSolutionID == item.ID && x.LikeOrDislike == 1);
                singleSPostSolutionInfo.DislikesNumber = item.SolutionLikes.Count(x => x.PostSolutionID == item.ID && x.LikeOrDislike == -1);
                singleSPostSolutionInfo.SolutionPhoto = item.ImagePath;
                singleSPostSolutionInfo.UserID = item.UserID;
                singleSPostSolutionInfo.Awarded = item.isAwarded;
                singleSPostSolutionInfo.PostID = item.PostID;
                singleSPostSolutionInfo.PostActive = item.Post.Active;
                var isItLikedOrDisliked = item.SolutionLikes.FirstOrDefault(x => x.PostSolutionID == item.ID && x.UserDataID == userID);
                if (isItLikedOrDisliked == null)
                    singleSPostSolutionInfo.isLikedOrDisliked = 0;
                else
                {
                    singleSPostSolutionInfo.isLikedOrDisliked = isItLikedOrDisliked.LikeOrDislike;
                }

                listSolutions.Add(singleSPostSolutionInfo);
            }

            return listSolutions;

        }

        public List<PostInfo> topNLikedPosts(int n)
        {
            var posts = _context.Posts.Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();
            var listPosts =  GetAllPostInfoFunction(1, posts);

            listPosts = listPosts.OrderByDescending(x => x.LikesNumber).ToList();
            listPosts = listPosts.Take(n).ToList();

            return listPosts;
        }

        public List<PostInfo> activePosts(int userID)
        {
            var posts =  _context.Posts.Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();
            var listPosts =  GetAllPostInfoFunction(userID, posts);

            return listPosts.Where(x => x.Active == 1).ToList();
        }

        public List<PostInfo> PostsByMoreCategories(int userID, List<Category> categories, int cityID, int isActive, int pageIndex, int pageSize)
        {
            List<PostInfo> listPosts = new List<PostInfo>();
            if (categories.Count > 0)
            {
                foreach (var item in categories)
                {
                    List<Post> posts;
                    if (isActive == 1)
                        posts = _context.Posts.Where(x => x.CategoryID == item.ID && x.CityID == cityID && x.Active == isActive).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();
                    else
                        posts = _context.Posts.Where(x => x.CategoryID == item.ID && x.CityID == cityID).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();

                    if (posts.Count > 0)
                    {
                        var pomList = GetAllPostInfoFunction(userID, posts);
                        listPosts.AddRange(pomList);
                    }

                }
            }
            else
            {
                List<Post> postsPom;
                if (isActive == 1)
                    postsPom = _context.Posts.Where(x => x.CityID == cityID && x.Active == isActive).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();
                else
                    postsPom = _context.Posts.Where(x => x.CityID == cityID).Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();

               listPosts =  GetAllPostInfoFunction(userID, postsPom);
            }


            listPosts = listPosts.OrderByDescending(x => x.Time).ToList();

            return listPosts.Skip(pageSize * pageIndex).Take(pageSize).ToList();
        }

        public List<PostInfo> GetPostsByCityAndCategory(int userID,int categoryID, int cityID,int id)
        {
            List<Post> posts = new List<Post>();
            posts = _context.Posts.Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();

            if(categoryID == -1 && cityID != -1)
            {
                posts = posts.Where(x => x.CityID == cityID).ToList();
            }
            else if(categoryID != -1 && cityID == -1)
            {
                posts = posts.Where(x => x.CategoryID == categoryID).ToList();
            }
            else if (categoryID != -1 && cityID != -1)
            {
                posts = posts.Where(x => x.CategoryID == categoryID && x.CityID == cityID).ToList();
            }

            var pomPosts = GetAllPostInfoFunction(userID, posts);
            if(id== 1)
            {
                return pomPosts;
            }
            else if (id == 2)
            {
                var reportedPosts = GetAllPostReportsInfo();
                return reportedPosts.Where(item1 => pomPosts.Any(item2 => item1.ID == item2.ID)).ToList();
            }
            else if (id == 3)
            {
                var topPosts = topNLikedPosts(20);
                return topPosts.Where(item1 => pomPosts.Any(item2 => item1.ID == item2.ID)).ToList();
            }


            return pomPosts;

        }

        public  List<PostInfo> GetAllPostReportsInfo()
        {
            var postReports =  _context.PostReports.Include(x => x.UserData).Include(x => x.Post).Include(x => x.Post.Location).Include(x => x.Post.City).Include(x => x.Post.Category).ToList();

            List<PostInfo> listPri = new List<PostInfo>();

            foreach (var item in postReports)
            {
                PostInfo p = new PostInfo();

                p.ID = item.PostID;
                p.City = item.Post.City.Name;
                p.CategoryName = item.Post.Category.Name;
                p.Address = item.Post.Location.Address;
                p.CommentsNumber = _context.Comments.Count(x => x.PostID == item.PostID);
                p.LikesNumber = _context.PostLikes.Count(x => x.PostID == item.PostID);
                p.Title = item.Post.Title;
                p.PostImage = item.Post.PostImage;
                p.Active = item.Post.Active;
                p.Latitude = item.Post.Location.Latitude;
                p.Longitude = item.Post.Location.Longitude;
                p.Description = item.Post.Description;
                p.Time = item.Post.Time;
                p.FullName = item.Post.UserData.Name + " " + item.Post.UserData.Lastname;
                p.UserPhoto = item.Post.UserData.Photo;
                p.UserID = item.Post.UserDataID;
                p.ReportsNumber = _context.PostReports.Count(x => x.PostID == item.PostID);

                listPri.Add(p);
            }

            listPri = listPri.DistinctBy(x => x.ID).ToList();
            return listPri.OrderByDescending(x => x.ReportsNumber).ToList();
        }

        public bool AddSavedPost(SavedPost sp)
        {
            try
            {
                var savedPostExists = _context.SavedPosts.FirstOrDefault(x => x.OrganisationID == sp.OrganisationID && x.PostID == sp.PostID);
                if(savedPostExists != null)
                {
                    return false;
                }

                SavedPost newSp = new SavedPost();

                newSp.OrganisationID = sp.OrganisationID;
                newSp.PostID = sp.PostID;

                _context.SavedPosts.Add(newSp);
                _context.SaveChanges();

                return true;
            }
            catch (Exception)
            {

                return false;
            }
            
        }

        public List<PostInfo> SavedPostsByOrgID(int orgID)
        {
            var savedPosts = _context.SavedPosts.Where(x => x.OrganisationID == orgID).Include(x => x.Post).ToList();

            List<Post> nesto = new List<Post>();

            var posts = _context.Posts.Include(x => x.UserData).Include(x => x.Category).Include(x => x.PostLikes).Include(x => x.Location).Include(x => x.City).ToList();
            var allPosts =  GetAllPostInfoFunction(1, posts);


            return allPosts.Where(item1 => savedPosts.Any(item2 => item1.ID == item2.PostID)).ToList();
        }

        public bool AddPostSolution(PostSolution ps)
        {
            try
            {
                _context.PostSolutions.Add(ps);
                 _context.SaveChanges();

                Notification notify = new Notification();
                var solution = _context.PostSolutions.Include(x => x.Post).FirstOrDefault(x => x.ID == ps.ID);


                notify.UserID = solution.Post.UserDataID;
                notify.TypeOfNotification = 4;  //newSolution = 4
                notify.isRead = false;
                if(solution.UserType == 1) // user 1, org 2
                {
                    var user = _context.UserDatas.FirstOrDefault(x => x.ID == solution.UserID);
                    notify.Title = user.Name + " " + user.Lastname + " je dodao/la novo rešenje na Vašoj objavi " + solution.Post.Title;
                    //notify.Message = user.Name + " " + user.Lastname + " je dodao/la novo resenje na vasoj objavi " + solution.Post.Title;
                    notify.Message = DateTime.Now.ToString();
                    notify.UserNotificationMakerPhoto = user.Photo;

                }
                else if (solution.UserType == 2)
                {
                    var org = _context.Organisations.FirstOrDefault(x => x.ID == solution.UserID);

                    notify.Title = org.Name + " je dodao/la novo rešenje na Vašoj objavi " + solution.Post.Title;
                    //notify.Message = org.Name + " je dodao/la novo resenje na vasoj objavi " + solution.Post.Title;
                    notify.Message = DateTime.Now.ToString();
                    notify.UserNotificationMakerPhoto = org.ImagePath;

                }
                notify.NewThingID = solution.ID;
                notify.UserNotificationMakerID = solution.UserID;

                notify.NotificationForID = solution.Post.ID;

                if (notify.UserID != notify.UserNotificationMakerID && solution.UserType == 1)
                {
                    _context.Notifications.Add(notify);
                }
                if (solution.UserType == 2)
                {
                    _context.Notifications.Add(notify);
                }

                _context.SaveChanges();
                return true;

                //newSolution = 4
            }
            catch (Exception)
            {

                return false;
            }
            
        }

        public List<PostSolutionInfo> PostSolutionsByPostID(int postID, int userID)
        {
            var solutions = _context.PostSolutions.Where(x => x.PostID == postID).Include(x => x.Post).Include(x => x.SolutionLikes).ToList();

            List<PostSolutionInfo> listSolutions = new List<PostSolutionInfo>();
            foreach (var item in solutions)
            {
                PostSolutionInfo singleSPostSolutionInfo = new PostSolutionInfo();
                singleSPostSolutionInfo.ID = item.ID;

                //user 1, org 2
                if(item.UserType == 1)
                {
                    var user = _context.UserDatas.FirstOrDefault(x => x.ID == item.UserID);
                    singleSPostSolutionInfo.FullName = user.Name + " " + user.Lastname;
                    singleSPostSolutionInfo.UserPhoto = user.Photo;
                    
                }
                else if(item.UserType == 2)
                {
                    var org = _context.Organisations.FirstOrDefault(x => x.ID == item.UserID);
                    singleSPostSolutionInfo.FullName = org.Name;
                    singleSPostSolutionInfo.UserPhoto = org.ImagePath;
                }

                singleSPostSolutionInfo.UserType = item.UserType;
                singleSPostSolutionInfo.Text = item.Text;
                singleSPostSolutionInfo.LikesNumber = item.SolutionLikes.Count(x => x.PostSolutionID == item.ID && x.LikeOrDislike == 1);
                singleSPostSolutionInfo.DislikesNumber = item.SolutionLikes.Count(x => x.PostSolutionID == item.ID && x.LikeOrDislike == -1);
                singleSPostSolutionInfo.SolutionPhoto = item.ImagePath;
                singleSPostSolutionInfo.UserID = item.UserID;
                singleSPostSolutionInfo.Awarded = item.isAwarded;
                singleSPostSolutionInfo.PostID = item.PostID;
                singleSPostSolutionInfo.PostActive = item.Post.Active;
                var isItLikedOrDisliked = item.SolutionLikes.FirstOrDefault(x => x.PostSolutionID == item.ID && x.UserDataID == userID);
                if (isItLikedOrDisliked == null)
                    singleSPostSolutionInfo.isLikedOrDisliked = 0;
                else
                {
                    singleSPostSolutionInfo.isLikedOrDisliked = isItLikedOrDisliked.LikeOrDislike;
                }

                listSolutions.Add(singleSPostSolutionInfo);
            }

            listSolutions = listSolutions.OrderByDescending(x => x.UserType).ThenByDescending(x => x.Awarded).ToList();

            return listSolutions;
        }

        public async Task<ActionResult<bool>> DeleteSolution(int id)
        {
            try
            {
                var solution = await _context.PostSolutions.FindAsync(id);

                //deleting old photo
                if (solution.ImagePath != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(solution.ImagePath);
                }

                _context.PostSolutions.Remove(solution);

                var notify = _context.Notifications.FirstOrDefault(x => x.NewThingID == id && x.TypeOfNotification == 4);
                if(notify != null)
                {
                    _context.Notifications.Remove(notify);
                }

                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public ActionResult<string> SolutionLike(SolutionLike solutionLike)
        {
            var existingSolution = _context.SolutionLikes.FirstOrDefault(x => x.PostSolutionID == solutionLike.PostSolutionID && x.UserDataID == solutionLike.UserDataID);

            if (existingSolution == null)
            {
                try
                {
                    _context.SolutionLikes.Add(solutionLike);
                    _context.SaveChanges();

                    return "Like added";
                }
                catch (Exception)
                {

                    return "Wrong solutionID or UserID";
                }

            }
            else
            {
                if (solutionLike.LikeOrDislike == existingSolution.LikeOrDislike)
                {
                    try
                    {
                        _context.SolutionLikes.Remove(existingSolution);
                        _context.SaveChanges();
                        return "Like removed";
                    }
                    catch (Exception)
                    {

                        return "Wrong solutionID or UserID";
                    }

                }
                else
                {
                    try
                    {
                        existingSolution.LikeOrDislike *= -1;
                        _context.SolutionLikes.Update(existingSolution);
                        _context.SaveChanges();
                        return "Like edited";
                    }

                    catch (Exception)
                    {

                        return "Wrong solutionID or UserID";
                    }
                }


            }
        }

        public async Task<ActionResult<bool>> DeleteSavedPost(int postID, int orgID)
        {
            try
            {
                var savedPost = await _context.SavedPosts.FirstOrDefaultAsync(x => x.OrganisationID == orgID && x.PostID == postID);

                _context.SavedPosts.Remove(savedPost);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        public List<Notification> AllNotifications(int userID)
        {
            var notifications = _context.Notifications.Where(x => x.UserID == userID).ToList();


            List<Notification> listNotify = new List<Notification>();

            foreach (var item in notifications)
            {
                var nesto = _context.Notifications.Where(x => x.TypeOfNotification == item.TypeOfNotification && x.NotificationForID == item.NotificationForID).Count();
                if(nesto == 1)
                {
                    var checkIfAdded = listNotify.FirstOrDefault(x => x.TypeOfNotification == item.TypeOfNotification && x.NotificationForID == item.NotificationForID);
                    if(checkIfAdded == null)
                    {
                        
                        item.Message = RelativeDate(Convert.ToDateTime(item.Message));
                        listNotify.Add(item);
                    }
                }
                else
                {
                    var checkIfAdded = listNotify.FirstOrDefault(x => x.TypeOfNotification == item.TypeOfNotification && x.NotificationForID == item.NotificationForID);
                    if (checkIfAdded == null)
                    {
                        //item.Message += " i " + (nesto - 1) + " ostalih";
                        item.Title += " i " + (nesto - 1) + " ostalih";
                        item.Message = RelativeDate(Convert.ToDateTime(item.Message));
                        listNotify.Add(item);
                    }
                    
                }

            }

            listNotify.Reverse();
            return listNotify;

            //notifications.Reverse();
           //return notifications;
        }

        public string RelativeDate(DateTime yourDate)
        {
            const int SECOND = 1;
            const int MINUTE = 60 * SECOND;
            const int HOUR = 60 * MINUTE;
            const int DAY = 24 * HOUR;
            const int MONTH = 30 * DAY;

            var ts = new TimeSpan(DateTime.Now.Ticks - yourDate.Ticks);
            double delta = Math.Abs(ts.TotalSeconds);

            if (delta < 1 * MINUTE)
                return ts.Seconds == 1 ? "pre jedne sekunde" : "pre " + ts.Seconds + " sekundi";

            if (delta < 2 * MINUTE)
                return "pre jednog minuta";

            if (delta < 45 * MINUTE)
                return "pre " + ts.Minutes + " minuta";

            if (delta < 90 * MINUTE)
                return "pre jednog sata";

            if (delta < 24 * HOUR)
                return "pre " + ts.Hours + " sati";

            if (delta < 48 * HOUR)
                return "juce";

            if (delta < 30 * DAY)
                return "pre " + ts.Days + " dana";

            if (delta < 12 * MONTH)
            {
                int months = Convert.ToInt32(Math.Floor((double)ts.Days / 30));
                return months <= 1 ? "pre mesec dana" : "pre " + months + " meseci";
            }
            else
            {
                int years = Convert.ToInt32(Math.Floor((double)ts.Days / 365));
                return years <= 1 ? "pre godinu dana" : "pre " + years + " godina";
            }
        }

        //public string RelativeDate(DateTime yourDate)
        //{
        //    const int SECOND = 1;
        //    const int MINUTE = 60 * SECOND;
        //    const int HOUR = 60 * MINUTE;
        //    const int DAY = 24 * HOUR;
        //    const int MONTH = 30 * DAY;

        //    var ts = new TimeSpan(DateTime.UtcNow.Ticks - yourDate.Ticks);
        //    double delta = Math.Abs(ts.TotalSeconds);

        //    if (delta < 1 * MINUTE)
        //        return ts.Seconds == 1 ? "one second ago" : ts.Seconds + " seconds ago";

        //    if (delta < 2 * MINUTE)
        //        return "a minute ago";

        //    if (delta < 45 * MINUTE)
        //        return ts.Minutes + " minutes ago";

        //    if (delta < 90 * MINUTE)
        //        return "an hour ago";

        //    if (delta < 24 * HOUR)
        //        return ts.Hours + " hours ago";

        //    if (delta < 48 * HOUR)
        //        return "yesterday";

        //    if (delta < 30 * DAY)
        //        return ts.Days + " days ago";

        //    if (delta < 12 * MONTH)
        //    {
        //        int months = Convert.ToInt32(Math.Floor((double)ts.Days / 30));
        //        return months <= 1 ? "one month ago" : months + " months ago";
        //    }
        //    else
        //    {
        //        int years = Convert.ToInt32(Math.Floor((double)ts.Days / 365));
        //        return years <= 1 ? "one year ago" : years + " years ago";
        //    }
        //}


    }



}
