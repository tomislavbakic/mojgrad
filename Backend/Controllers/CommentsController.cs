using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.UI;
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CommentsController : ControllerBase
    {
        private readonly ICommentsUI _ICommentsUI;

        public CommentsController(ICommentsUI ICommentsUI)
        {
            _ICommentsUI = ICommentsUI;
        }

        [Authorize]
        [HttpPost]
        [Route("Likes")]
        public ActionResult<string> CommentLike(CommentLike commentLike)
        {
            return _ICommentsUI.CommentLike(commentLike);
        }

        [Authorize]
        [HttpPost]
        public Task<ActionResult<Comment>> PostComment(Comment comment)
        {
            return _ICommentsUI.PostComment(comment);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<string>> DeleteComment(int id)
        {
            return await  _ICommentsUI.DeleteComment(id);
        }
    }
}
