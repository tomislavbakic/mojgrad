using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class CommentReportsDAL : ICommentReportsDAL
    {
        private readonly DataContext _context;

        public CommentReportsDAL(DataContext context)
        {
            _context = context;
        }

        public async Task AddCommentReport(CommentReport commentReport)
        {
            try
            {
                _context.CommentReports.Add(commentReport);
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {

                throw;
            }
        }

        public async Task<ActionResult<bool>> DeleteCommentReport(int id)
        {
            var commentReport = await _context.CommentReports.FirstOrDefaultAsync(x => x.ID == id);
            if (commentReport == null)
                return false;

            try
            {
                _context.CommentReports.Remove(commentReport);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }


        public async Task<ActionResult<IEnumerable<CommentReportInfo>>> GetCommentReportsInfo()
        {
            var commentReports = await _context.CommentReports.Include(x => x.UserData).Include(x => x.Comment).Include(x => x.Comment.Post).ToListAsync();

            List<CommentReportInfo> criList = new List<CommentReportInfo>();

            foreach (var item in commentReports)
            {
                CommentReportInfo cri = new CommentReportInfo();

                cri.ID = item.ID;
                cri.Description = item.Description;
                cri.CommentID = item.CommentID;
                cri.UserDataID = item.Comment.UserDataID;
                cri.UserFullname = item.UserData.Name + " " + item.UserData.Lastname;
                cri.CommentText = item.Comment.Text;
                cri.CommentPhoto = item.Comment.CommentPhoto;
                cri.postID = item.Comment.Post.ID;
                cri.userPhoto = item.UserData.Photo;
                var isBlocked = _context.BlockedUsers.FirstOrDefault(x => x.UserDataID == item.UserData.ID);
                if (isBlocked == null)
                    cri.isBlocked = 0;
                else
                    cri.isBlocked = 1;

                criList.Add(cri);
            }
            return criList;
        }
    }
}
