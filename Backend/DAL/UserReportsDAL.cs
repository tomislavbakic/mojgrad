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
    public class UserReportsDAL : IUserReportsDAL
    {
        private readonly DataContext _context;

        public UserReportsDAL(DataContext context)
        {
            _context = context;
        }
        public async Task<ActionResult<bool>> DeleteUserReport(int id)
        {
            var userReport = await _context.UserReports.FirstOrDefaultAsync(x => x.ID == id);
            if (userReport == null)
                return false;

            try
            {
                _context.UserReports.Remove(userReport);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }

        public async Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReportByID(int id)
        {
            var userReports = await _context.UserReports.Where(x => x.ReportedUserID == id).ToListAsync();
            return GetUserReportsFunction(userReports);

        }

        public async Task<ActionResult<IEnumerable<UserReportInfo>>> GetUserReports()
        {
            var userReports = await _context.UserReports.ToListAsync();
            return GetUserReportsFunction(userReports);
        }

        private ActionResult<IEnumerable<UserReportInfo>> GetUserReportsFunction(List<UserReport> userReports)
        {
            List<UserReportInfo> urInfoList = new List<UserReportInfo>();

            foreach (var item in userReports)
            {
                UserReportInfo urInfo = new UserReportInfo();

                var user = _context.UserDatas.Include(x => x.City).Include(x => x.Rank).FirstOrDefault(x => x.ID == item.ReportedUserID);

                urInfo.ID = item.ID;
                urInfo.FullName = user.Name + " " + user.Lastname;
                urInfo.Email = user.Email;
                urInfo.Eko = 0;
                urInfo.Photo = user.Photo;
                urInfo.CityName = user.City.Name;
                urInfo.ReportedUserID = item.ReportedUserID;
                urInfo.Description = item.Description;
                urInfo.RankName = user.Rank.Name;

                urInfo.Eko = _context.PostLikes.Where(x => x.PostID == x.Post.ID && x.Post.UserDataID == user.ID && x.Post.UserDataID != x.UserDataID).Count()
                    + _context.CommentLikes.Where(x => x.CommentID == x.Comment.ID && x.Comment.UserDataID == user.ID && x.Comment.UserDataID != x.UserDataID && x.LikeOrDislike == 1).Count()
                    - _context.CommentLikes.Where(x => x.CommentID == x.Comment.ID && x.Comment.UserDataID == user.ID && x.Comment.UserDataID != x.UserDataID && x.LikeOrDislike == -1).Count();

                if (urInfo.Eko < 0)
                    urInfo.Eko = 0;

                urInfoList.Add(urInfo);
            }

            return urInfoList;
        }

        public async Task PostUserReport(UserReport userReport)
        {
            try
            {
                _context.UserReports.Add(userReport);
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {

                throw;
            }
        }


    }
}
