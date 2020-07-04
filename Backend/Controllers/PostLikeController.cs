using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PostLikeController : ControllerBase
    {
        private readonly IPostLikeUI _iPostLikeUI;

        public PostLikeController(IPostLikeUI iPostLikeUI)
        {
            _iPostLikeUI = iPostLikeUI;
        }

        [Authorize]
        [HttpGet("{id}")]
        public List<UserPostLikes> GetUsers(int id)
        {
            return _iPostLikeUI.GetUsersWhoLikedPost(id);
        }
    }



}