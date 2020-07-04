using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IFeedbacksDAL
    {
        Task<ActionResult<IEnumerable<FeedbacksInfo>>> GetFeedbacks();
        Task AddFeedback(Feedback feedback);
    }
}
