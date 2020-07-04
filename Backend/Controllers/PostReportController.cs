using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostReportController : ControllerBase
    {
        private readonly IPostReportUI _iPostReportUI;

        public PostReportController(IPostReportUI iPostReportUI)
        {
            _iPostReportUI = iPostReportUI;
        }

        /*
        //[Authorize]
        [HttpGet]
        public List<PostReport> GetPostReports()
        {
            return _iPostReportUI.GetPostReports();
        }*/

        [Authorize]
        [HttpGet]
        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostReportsInfo()
        {
            return _iPostReportUI.GetAllPostReportsInfo();
        }

        [Authorize]
        [HttpGet("{id}")]
        public List<PostReport> GetPostReportsByPostID(int id)
        {
            return _iPostReportUI.GetPostReportsByPostID(id);
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<PostReport>> AddPostReport(PostReport postReport)
        {
            await _iPostReportUI.AddPostReport(postReport);


            return Ok();
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<ActionResult<bool>> DeletePostReport(int id)
        {
            return await _iPostReportUI.DeletePostReport(id);
        }
    }
}