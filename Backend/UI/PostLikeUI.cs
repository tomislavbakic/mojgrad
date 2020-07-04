using Backend.BL.Interfaces;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class PostLikeUI : IPostLikeUI
    {
        private readonly IPostLikeBL _iPostLikeBL;

        public PostLikeUI(IPostLikeBL iPostLikeBL)
        {
            _iPostLikeBL = iPostLikeBL;
        }

        public List<UserPostLikes> GetUsersWhoLikedPost(int id)
        {
            return _iPostLikeBL.GetUsersWhoLikedPost(id);
        }
    }
}
