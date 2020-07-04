using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CommentReportsController : ControllerBase
    {
        private readonly ICommentReportsUI _ICommentReportsUI;

        public CommentReportsController(ICommentReportsUI ICommentReportsUI)
        {
            _ICommentReportsUI = ICommentReportsUI;
        }

        // GET: api/CommentReports
        [Authorize]
        [HttpGet]
        public  Task<ActionResult<IEnumerable<CommentReportInfo>>> GetCommentReportsInfo()
        {
            return _ICommentReportsUI.GetCommentReportsInfo();
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<CommentReport>> AddCommentReport(CommentReport commentReport)
        {
            await _ICommentReportsUI.AddCommentReport(commentReport);


            return Ok();
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<bool>> DeleteCommentReport(int id)
        {
            return await _ICommentReportsUI.DeleteCommentReport(id);
        }


    }
}
