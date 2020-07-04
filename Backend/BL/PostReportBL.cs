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
    public class PostReportBL : IPostReportBL
    {
        private readonly IPostReportDAL _iPostReportDAL;

        public PostReportBL(IPostReportDAL iPostReportDAL)
        {
            _iPostReportDAL = iPostReportDAL;
        }

        public Task AddPostReport(PostReport postReport)
        {
            return _iPostReportDAL.AddPostReport(postReport);
        }

        public Task<ActionResult<bool>> DeletePostReport(int id)
        {
            return _iPostReportDAL.DeletePostReport(id);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostReportsInfo()
        {
            return _iPostReportDAL.GetAllPostReportsInfo();
        }

        public List<PostReport> GetPostReports()
        {
            return _iPostReportDAL.GetAllPostsReports().ToList();
        }

        public List<PostReport> GetPostReportsByPostID(int postID)
        {
            return _iPostReportDAL.GetAllPostsReportsByPostID(postID).ToList(); 
        }
    }
}
