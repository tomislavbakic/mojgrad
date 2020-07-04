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
    public class FeedbacksUI : IFeedbacksUI
    {
        private readonly IFeedbacksBL _IFeedbacksBL;

        public FeedbacksUI(IFeedbacksBL IFeedbacksBL)
        {
            _IFeedbacksBL = IFeedbacksBL;
        }

        public Task AddFeedback(Feedback feedback)
        {
            return _IFeedbacksBL.AddFeedback(feedback);
        }

        public Task<ActionResult<IEnumerable<FeedbacksInfo>>> GetFeedbacks()
        {
            return _IFeedbacksBL.GetFeedbacks();
        }
    }
}
