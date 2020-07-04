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
    public class PostReportUI : IPostReportUI
    {
        private readonly IPostReportBL _iPostReportBL;

        public PostReportUI(IPostReportBL iPostReportBL)
        {
            _iPostReportBL = iPostReportBL;
        }

        public Task AddPostReport(PostReport postReport)
        {
            return _iPostReportBL.AddPostReport(postReport);
        }

        public Task<ActionResult<bool>> DeletePostReport(int id)
        {
            return _iPostReportBL.DeletePostReport(id);
        }

        public Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostReportsInfo()
        {
            return _iPostReportBL.GetAllPostReportsInfo();
        }

        public List<PostReport> GetPostReports()
        {
            return _iPostReportBL.GetPostReports().ToList();
        }

        public List<PostReport> GetPostReportsByPostID(int postID)
        {
            return _iPostReportBL.GetPostReportsByPostID(postID).ToList();
        }
    }
}
