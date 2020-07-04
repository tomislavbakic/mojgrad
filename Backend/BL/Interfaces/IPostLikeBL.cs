using Backend.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface IPostLikeBL
    {
        List<UserPostLikes> GetUsersWhoLikedPost(int id);
    }
}
