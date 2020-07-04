using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Backend.Models.ViewModels;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostsController : ControllerBase
    {
        private readonly IPostsUI _IPostsUI;


        public PostsController(IPostsUI IPostsUI)
        {
            _IPostsUI = IPostsUI;
        }



        [Authorize]
        [Route("byUser/{id}/userid={userID}")]
        [HttpGet]
        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfoByUser(int id,int userID)
        {
            return _IPostsUI.GetAllPostsInfoByUser(id, userID);

        }


        [Authorize]
        [HttpGet("userid={userID}")]
        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfo(int userID)
        {
            return _IPostsUI.GetAllPostsInfo(userID);
        }

        [Authorize]
        [Route("{id:int}/Comments/userid={userID}")]
        [HttpGet]
        public Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComents(int id, int userID)
        {
            return _IPostsUI.GetAllComents(id, userID);
        }

        [Authorize]
        [HttpGet("{id}/userid={userID}")]
        public Task<ActionResult<PostInfo>> GetPost(int id, int userID)
        {
            return _IPostsUI.GetPost(id, userID);
        }

        [Authorize]
        [Route("categoty/{id}/userid={userID}")]
        [HttpGet]
        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCategory(int id, int userID)
        {
            return _IPostsUI.GetAllPostsByCategory(id,userID);

        }

        [Authorize]
        [Route("city/{id}/userid={userID}")]
        [HttpGet]
        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsByCity(int id, int userID)
        {
            return _IPostsUI.GetAllPostsByCity(id, userID);

        }

        [Authorize]
        [HttpGet]
        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostsInfo()
        {
            return _IPostsUI.GetAllPostsInfoNoID();
        }

        [Authorize]
        [Route("{id:int}/Comments")]
        [HttpGet]
        public Task<ActionResult<IEnumerable<CommentInfo>>> GetAllComents(int id)
        {
            return _IPostsUI.GetAllComentsNoID(id);
        }

        [Authorize]
        [HttpGet("{id}")]
        public Task<ActionResult<PostInfo>> GetPost(int id)
        {
            return _IPostsUI.GetPostNoID(id);
        }

        [Authorize]
        [Route("Likes")]
        [HttpPost]
        public ActionResult<string> PostLike(PostLike postLike)
        {
            return _IPostsUI.PostLike(postLike);
        }


        [Authorize]
        [HttpPost]
        public async Task<ActionResult<Post>> PostPost(AddPostAndLocation apal)
        {
            await _IPostsUI.SavePostAndLocation(apal);

            return Ok();
        }

        // DELETE: api/Posts/5
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<string>> DeletePost(int id)
        {
            return await _IPostsUI.DeletePost(id);

        }

        [Authorize]
        [Route("changePost")]
        [HttpPut] 
        public async Task<ActionResult<bool>> EditPost(ChangePost changePost)
        {
            return await _IPostsUI.EditPost(changePost);

        }

        [Authorize]
        [Route("CategoryInfo")]
        [HttpGet]
        public ActionResult<List<CategoryInfo>> GetPercentageOfPostsByCategory()
        {
            return _IPostsUI.GetPercentageOfPostsByCategory();
        }

        [Authorize]
        [Route("CloseChallange/{postID}")]
        [HttpPost]
        public ActionResult<string> CloseChallangePost(int postID)
        {
            return _IPostsUI.CloseChallange(postID);
        }


        [Authorize]
        [Route("topNLikedPosts/{n}")]
        [HttpGet]
        public List<PostInfo> topNLikedPosts(int n)
        {
            return _IPostsUI.topNLikedPosts(n);
        }

        [Authorize]
        [Route("activePosts/{userID}")]
        [HttpGet]
        public List<PostInfo> ActivePosts(int userID)
        {
            return _IPostsUI.activePosts(userID);
        }

        [Authorize]
        [Route("cityCategoryFilter/{userID}/city={cityID}/active={isActive}/pageIndex={pageIndex}/pageSize={pageSize}")]
        [HttpPost]
        public List<PostInfo> PostsByMoreCategories(int userID, List<Category> categories, int cityID,int isActive,int pageIndex,int pageSize)
        {
            return _IPostsUI.PostsByMoreCategories(userID,categories,cityID, isActive, pageIndex, pageSize);
        }

        [Authorize]
        [Route("beautifulPosts/{userID}/city={cityID}")]
        [HttpGet]
        public List<PostInfo> GetBeautifulPosts(int userID,int cityID)
        {
            return _IPostsUI.GetBeautifulPosts(userID,cityID);
        }


        //1 sve, 2 prijavljene, 3 najbolje
        [Route("PostsByCityAndCategory/userID={userID}/category={categoryID}/city={cityID}/{id}")]
        [HttpGet]
        public List<PostInfo> GetPostsByCityAndCategory(int userID, int categoryID, int cityID,int id)
        {
            return _IPostsUI.GetPostsByCityAndCategory(userID, categoryID, cityID,id);
        }

        [Authorize]
        [Route("addSavedPost")]
        [HttpPost]
        public bool AddSavedPost(SavedPost sp)
        {
            return _IPostsUI.AddSavedPost(sp);
        }

        [Authorize]
        [Route("SavedPosts/{orgID}")]
        [HttpGet]
        public List<PostInfo> SavedPostsByOrgID(int orgID)
        {
            return _IPostsUI.SavedPostsByOrgID(orgID);
        }

        [Authorize]
        [Route("DeleteSavedPost/post={postID}/org={orgID}")]
        [HttpDelete]
        public async Task<ActionResult<bool>> DeleteSavedPost(int postID,int orgID)
        {
            return await _IPostsUI.DeleteSavedPost(postID,orgID);
        }

        [Authorize]
        [Route("addPostSolution")]
        [HttpPost]
        public bool AddPostSolution(PostSolution ps)
        {
            return _IPostsUI.AddPostSolution(ps);
        }


        [Authorize]
        [Route("PostSolutions/{postID}/userid={userID}")]
        [HttpGet]
        public List<PostSolutionInfo> PostSolutionsByPostID(int postID,int userID)
        {
            return _IPostsUI.PostSolutionsByPostID(postID,userID);
        }

        [Authorize]
        [Route("PostSolutions/{id}")]
        [HttpDelete]
        public async Task<ActionResult<bool>> DeleteSolution(int id)
        {
            return await _IPostsUI.DeleteSolution(id);
        }

        [Authorize]
        [HttpPost]
        [Route("SolutionLikes")]
        public ActionResult<string> SolutionLike(SolutionLike solutionLike)
        {
            return _IPostsUI.SolutionLike(solutionLike);
        }

        [Authorize]
        [Route("AllNotifications/{userID}")]
        [HttpGet]
        public List<Notification> AllNotifications(int userID)
        {
            return _IPostsUI.AllNotifications(userID);
        }

        [Authorize]
        [Route("awardedSolutions/{userID}")]
        [HttpGet]
        public List<PostSolutionInfo> GetAwardedSolutionByUserID(int userID)
        {
            return _IPostsUI.GetAwardedSolutionByUserID(userID);
        }

    }
}
    
