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
    public class PostReportDAL : IPostReportDAL
    {
        private readonly DataContext _context;

        public PostReportDAL(DataContext context)
        {
            _context = context;
        }

        public async Task AddPostReport(PostReport postReport)
        {
            try
            {
                _context.PostReports.Add(postReport);
                await _context.SaveChangesAsync();
            }
            catch (Exception)
            {

                throw;
            }
        }

        public async Task<ActionResult<bool>> DeletePostReport(int id)
        {
            var postReport = await _context.PostReports.FirstOrDefaultAsync(x => x.ID == id);
            if (postReport == null)
                return false;

            try
            {
                _context.PostReports.Remove(postReport);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }

        public async Task<ActionResult<IEnumerable<PostInfo>>> GetAllPostReportsInfo()
        {
            var postReports = await _context.PostReports.Include(x => x.UserData).Include(x => x.Post).Include(x => x.Post.Location).Include(x => x.Post.City).Include(x => x.Post.Category).ToListAsync();

            List<PostInfo> listPri = new List<PostInfo>();

            foreach (var item in postReports)
                {
                PostInfo p = new PostInfo();

                p.ID = item.PostID;
                p.City = item.Post.City.Name;
                p.CategoryName = item.Post.Category.Name;
                p.Address = item.Post.Location.Address;
                p.CommentsNumber = _context.Comments.Count(x => x.PostID == item.PostID);
                p.LikesNumber = _context.PostLikes.Count(x => x.PostID == item.PostID);
                p.Title = item.Post.Title;
                p.PostImage = item.Post.PostImage;
                p.Active = item.Post.Active;
                p.Latitude = item.Post.Location.Latitude;
                p.Longitude = item.Post.Location.Longitude;
                p.Description = item.Post.Description;
                p.Time = item.Post.Time;
                p.FullName = item.Post.UserData.Name + " " + item.Post.UserData.Lastname;
                p.UserPhoto = item.Post.UserData.Photo;
                p.UserID = item.Post.UserDataID;
                p.ReportsNumber = _context.PostReports.Count(x => x.PostID == item.PostID);

                listPri.Add(p);
            }

            listPri = listPri.DistinctBy(x => x.ID).ToList();
            return listPri.OrderByDescending(x => x.ReportsNumber).ToList();
        }

        public IEnumerable<PostReport> GetAllPostsReports()
        {
            return _context.PostReports.Include(x => x.UserData).Include(x => x.Post);
        }

       
        public IEnumerable<PostReport> GetAllPostsReportsByPostID(int postID)
        {
            return _context.PostReports.Include(x => x.UserData).Include(x => x.Post).Where(x => x.PostID.Equals(postID));
        }
    }
}
