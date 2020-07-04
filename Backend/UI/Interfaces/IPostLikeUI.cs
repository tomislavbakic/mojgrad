using Backend.Models.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface IPostLikeUI
    {
        List<UserPostLikes> GetUsersWhoLikedPost(int id);
    }
}
