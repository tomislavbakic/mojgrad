using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IPostsUI
    {
        public Task<ActionResult<IEnumerable<Post>>> GetAllPostsAsync();
        Task SavePost(Post post);
        Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfo(int userID);
        Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComents(int id,int userID);
        Task<ActionResult<PostInfo>> GetPost(int id,int userID);
        ActionResult<string> PostLike(PostLike postLike);
        Task<ActionResult<string>> DeletePost(int id);
        Task<ActionResult<bool>> EditPost(ChangePost changePost);
        Task SavePostAndLocation(AddPostAndLocation apal);
        Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoByUser(int id, int userID);
        Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoNoID();
        Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComentsNoID(int id);
        Task<ActionResult<PostInfo>> GetPostNoID(int id);
        Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCategory(int id, int userID);
        Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCity(int id, int userID);
        public List<CategoryInfo> GetPercentageOfPostsByCategory();
        string CloseChallange(int id);
        List<PostSolutionInfo> GetAwardedSolutionByUserID(int userID);
        List<PostInfo> topNLikedPosts(int n);
        List<PostInfo> activePosts(int userID);
        List<PostInfo> PostsByMoreCategories(int userID, List<Category> categories, int cityID, int isActive, int pageIndex, int pageSize);
        List<PostInfo> GetBeautifulPosts(int userID, int cityID);
        List<PostInfo> GetPostsByCityAndCategory(int userID, int categoryID, int cityID,int id);
        bool AddSavedPost(SavedPost sp);
        List<PostInfo> SavedPostsByOrgID(int orgID);
        bool AddPostSolution(PostSolution ps);
        List<PostSolutionInfo> PostSolutionsByPostID(int postID, int userID);
        Task<ActionResult<bool>> DeleteSolution(int id);
        ActionResult<string> SolutionLike(SolutionLike solutionLike);
        Task<ActionResult<bool>> DeleteSavedPost(int postID, int orgID);
        List<Notification> AllNotifications(int userID);
    }
}
