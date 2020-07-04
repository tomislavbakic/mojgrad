using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class PostsBL : IPostsBL
    {
        private readonly IPostsDAL _IPostsDAL;
        public PostsBL(IPostsDAL IPostsDAL)
        {
            _IPostsDAL = IPostsDAL;
        }

        public Task<ActionResult<string>> DeletePost(int id)
        {
            return _IPostsDAL.DeletePost(id);
        }

        public Task<ActionResult<bool>> EditPost(ChangePost changePost)
        {
            return _IPostsDAL.EditPost(changePost);
        }

        public Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComents(int id,int userID)
        {
            return _IPostsDAL.GetAllComents(id, userID);
        }

        public Task<ActionResult<IEnumerable<Post>>> GetAllPostsAsync()
        {
            return _IPostsDAL.GetAllPostsAsync();
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCategory(int id, int userID)
        {
            return _IPostsDAL.GetAllPostsByCategory(id, userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCity(int id, int userID)
        {
            return _IPostsDAL.GetAllPostsByCity(id, userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfo(int userID)
        {
            return _IPostsDAL.GetAllPostsInfo(userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoByUser(int id, int userID)
        {
            return _IPostsDAL.GetAllPostsInfoByUser(id,userID);
        }

        public Task<ActionResult<PostInfo>> GetPost(int id,int userID)
        {
            return _IPostsDAL.GetPost(id, userID);
        }

        public ActionResult<string> PostLike(PostLike postLike)
        {
            return _IPostsDAL.PostLike(postLike);
        }

        public Task SavePost(Post post)
        {
            return _IPostsDAL.SavePostAsync(post);
        }

        public Task SavePostAndLocation(AddPostAndLocation apal)
        {
            return _IPostsDAL.SavePostAndLocation(apal);
        }

        public List<CategoryInfo> GetPercentageOfPostsByCategory()
        {
            return _IPostsDAL.GetPercentageOfPostsByCategory();
        }

        public string CloseChallange(int id)
        {
            return _IPostsDAL.CloseChallange(id);
        }

        public List<PostSolutionInfo> GetAwardedSolutionByUserID(int userID)
        {
            return _IPostsDAL.GetAwardedSolutionByUserID(userID);
        }

        public List<PostInfo> topNLikedPosts(int n)
        {
            return _IPostsDAL.topNLikedPosts(n);
        }

        public List<PostInfo> activePosts(int userID)
        {
            return _IPostsDAL.activePosts(userID);
        }

        public List<PostInfo> PostsByMoreCategories(int userID, List<Category> categories, int cityID, int isActive, int pageIndex, int pageSize)
        {
            return _IPostsDAL.PostsByMoreCategories(userID, categories,cityID,isActive,pageIndex, pageSize);
        }

        public List<PostInfo> GetBeautifulPosts(int userID, int cityID)
        {
            List<Category> category = new List<Category>();
            Category cat = new Category();
            cat.ID = 1;
            cat.Name = "Lepša strana grada";
            category.Add(cat);
            var x = _IPostsDAL.PostsByMoreCategories(userID,category,cityID,1, 0, 6);
            
            var beauty = x.Take(6).ToList();

            return beauty;
        }

        public List<PostInfo> GetPostsByCityAndCategory(int userID, int categoryID, int cityID,int id)
        {
            return _IPostsDAL.GetPostsByCityAndCategory(userID, categoryID, cityID,id);

        }

        public bool AddSavedPost(SavedPost sp)
        {
            return _IPostsDAL.AddSavedPost(sp);
        }

        public List<PostInfo> SavedPostsByOrgID(int orgID)
        {
            return _IPostsDAL.SavedPostsByOrgID(orgID);
        }

        public bool AddPostSolution(PostSolution ps)
        {
            return _IPostsDAL.AddPostSolution(ps);
        }

        public List<PostSolutionInfo> PostSolutionsByPostID(int postID, int userID)
        {
            return _IPostsDAL.PostSolutionsByPostID(postID, userID);
        }

        public Task<ActionResult<bool>> DeleteSolution(int id)
        {
            return _IPostsDAL.DeleteSolution(id);
        }

        public ActionResult<string> SolutionLike(SolutionLike solutionLike)
        {
            return _IPostsDAL.SolutionLike(solutionLike);
        }

        public Task<ActionResult<bool>> DeleteSavedPost(int postID, int orgID)
        {
            return _IPostsDAL.DeleteSavedPost(postID,orgID);
        }

        public List<Notification> AllNotifications(int userID)
        {
            return _IPostsDAL.AllNotifications(userID);
        }
    }
}
