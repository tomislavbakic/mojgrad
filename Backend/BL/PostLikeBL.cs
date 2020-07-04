using Backend.BL.Interfaces;
using Backend.DAL.Interfaces;
using Backend.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL
{
    public class PostLikeBL : IPostLikeBL
    {
        private readonly IPostLikeDAL _iPostLikeDAL;

        public PostLikeBL(IPostLikeDAL iPostLikeDAL)
        {
            _iPostLikeDAL = iPostLikeDAL;
        }

        public List<UserPostLikes> GetUsersWhoLikedPost(int id)
        {
            return _iPostLikeDAL.GetUsersWhoLikedPost(id).ToList();
        }
    }
}
