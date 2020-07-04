using Backend.BL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class PostsUI : IPostsUI
    {
        private readonly IPostsBL _IPostsBL;

        public PostsUI(IPostsBL IPostsBL)
        {
            _IPostsBL = IPostsBL;
        }

        public Task<ActionResult<string>> DeletePost(int id)
        {
            return _IPostsBL.DeletePost(id);
        }

        public Task<ActionResult<bool>> EditPost(ChangePost changePost)
        {
            return _IPostsBL.EditPost(changePost);
        }

        public Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComents(int id,int userID)
        {
            return _IPostsBL.GetAllComents(id, userID);
        }

        public Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComentsNoID(int id)
        {
            return _IPostsBL.GetAllComents(id, 1);
        }

        public Task<ActionResult<IEnumerable<Post>>> GetAllPostsAsync()
        {
            return _IPostsBL.GetAllPostsAsync();
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCategory(int id, int userID)
        {
            return _IPostsBL.GetAllPostsByCategory(id, userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCity(int id, int userID)
        {
            return _IPostsBL.GetAllPostsByCity(id, userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfo(int userID)
        {
            return _IPostsBL.GetAllPostsInfo(userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoByUser(int id, int userID)
        {
            return _IPostsBL.GetAllPostsInfoByUser(id,userID);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoNoID()
        {
            return _IPostsBL.GetAllPostsInfo(1);
        }

        public Task<ActionResult<PostInfo>> GetPost(int id,int userID)
        {
            return _IPostsBL.GetPost(id, userID);
        }

        public Task<ActionResult<PostInfo>> GetPostNoID(int id)
        {
            return _IPostsBL.GetPost(id, 1);
        }

        public ActionResult<string> PostLike(PostLike postLike)
        {
            return _IPostsBL.PostLike(postLike);
        }

        public Task SavePost(Post post)
        {
            return _IPostsBL.SavePost(post);
        }

        public Task SavePostAndLocation(AddPostAndLocation apal)
        {
            return _IPostsBL.SavePostAndLocation(apal);
        }

        public List<CategoryInfo> GetPercentageOfPostsByCategory()
        {
            return _IPostsBL.GetPercentageOfPostsByCategory();
        }

        public string CloseChallange(int id)
        {
            return _IPostsBL.CloseChallange(id);
        }

        public List<PostSolutionInfo> GetAwardedSolutionByUserID(int userID)
        {
            return _IPostsBL.GetAwardedSolutionByUserID(userID);
        }

        public List<PostInfo> topNLikedPosts(int n)
        {
            return _IPostsBL.topNLikedPosts(n);
        }

        public List<PostInfo> activePosts(int userID)
        {
            return _IPostsBL.activePosts(userID);
        }

        public List<PostInfo> PostsByMoreCategories(int userID, List<Category> categories, int cityID, int isActive, int pageIndex, int pageSize)
        {
            return _IPostsBL.PostsByMoreCategories(userID, categories, cityID, isActive, pageIndex, pageSize);
        }

        public List<PostInfo> GetBeautifulPosts(int userID, int cityID)
        {
            return _IPostsBL.GetBeautifulPosts(userID,cityID);
        }

        public List<PostInfo> GetPostsByCityAndCategory(int userID, int categoryID, int cityID, int id)
        {
            return _IPostsBL.GetPostsByCityAndCategory(userID, categoryID, cityID,id);
        }

        public bool AddSavedPost(SavedPost sp)
        {
            return _IPostsBL.AddSavedPost(sp);
        }

        public List<PostInfo> SavedPostsByOrgID(int orgID)
        {
            return _IPostsBL.SavedPostsByOrgID(orgID);
        }

        public bool AddPostSolution(PostSolution ps)
        {
            return _IPostsBL.AddPostSolution(ps);
        }

        public List<PostSolutionInfo> PostSolutionsByPostID(int postID, int userID)
        {
            return _IPostsBL.PostSolutionsByPostID(postID, userID);
        }

        public Task<ActionResult<bool>> DeleteSolution(int id)
        {
            return _IPostsBL.DeleteSolution(id);
        }

        public ActionResult<string> SolutionLike(SolutionLike solutionLike)
        {
            return _IPostsBL.SolutionLike(solutionLike);
        }

        public Task<ActionResult<bool>> DeleteSavedPost(int postID, int orgID)
        {
            return _IPostsBL.DeleteSavedPost(postID,orgID);
        }

        public List<Notification> AllNotifications(int userID)
        {
            return _IPostsBL.AllNotifications(userID);
        }
    }
}
