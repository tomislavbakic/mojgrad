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
    public class FeedbacksDAL : IFeedbacksDAL
    {
        private readonly DataContext _context;

        public FeedbacksDAL(DataContext context)
        {
            _context = context;
        }

        public async Task AddFeedback(Feedback feedback)
        {
            _context.Feedbacks.Add(feedback);
            await _context.SaveChangesAsync();
        }

        public async Task<ActionResult<IEnumerable<FeedbacksInfo>>> GetFeedbacks()
        {
            var feedbacks = await _context.Feedbacks.Include(x => x.UserData).ToListAsync();
            List<FeedbacksInfo> FeedbacksInfo = new List<FeedbacksInfo>();

            foreach (var item in feedbacks)
            {
                FeedbacksInfo fdi = new FeedbacksInfo();
                fdi.ID = item.ID;
                fdi.Text = item.Text;
                fdi.UserDataID = item.UserDataID;
                fdi.FullName = item.UserData.Name + " " + item.UserData.Lastname;
                fdi.userPhoto = item.UserData.Photo;

                FeedbacksInfo.Add(fdi);
            }

            return FeedbacksInfo;
        }
    }
}
