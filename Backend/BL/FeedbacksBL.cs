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
    public class FeedbacksBL : IFeedbacksBL
    {
        private readonly IFeedbacksDAL _IFeedbacksDAL;
        
        public FeedbacksBL(IFeedbacksDAL IFeedbacksDAL)
        {
            _IFeedbacksDAL = IFeedbacksDAL;
        }

        public Task AddFeedback(Feedback feedback)
        {
            return _IFeedbacksDAL.AddFeedback(feedback);
        }

        public Task<ActionResult<IEnumerable<FeedbacksInfo>>> GetFeedbacks()
        {
            return _IFeedbacksDAL.GetFeedbacks();
        }
    }
}
