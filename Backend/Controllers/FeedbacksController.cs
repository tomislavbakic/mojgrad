using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.UI.Interfaces;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Authorization;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class FeedbacksController : ControllerBase
    {
        private readonly IFeedbacksUI _IFeedbacksUI;

        public FeedbacksController(IFeedbacksUI IFeedbacksUI)
        {
            _IFeedbacksUI = IFeedbacksUI;
        }

        [Authorize]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<FeedbacksInfo>>> GetFeedbacks()
        {
            return await _IFeedbacksUI.GetFeedbacks();
        }

        [Authorize]
        [HttpPost]
        public async Task<ActionResult<Feedback>> AddFeedback(Feedback feedback)
        {
            await _IFeedbacksUI.AddFeedback(feedback);
            return Ok();
            //return CreatedAtAction("GetPost", new { id = feedback.ID }, feedback);
        }

    }
}
