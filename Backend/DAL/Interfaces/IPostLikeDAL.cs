using Backend.Models;
using Backend.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IPostLikeDAL
    {
        IEnumerable<UserPostLikes> GetUsersWhoLikedPost(int id);
    }
}
