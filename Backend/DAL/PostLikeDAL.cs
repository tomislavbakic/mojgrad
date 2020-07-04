using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class PostLikeDAL : IPostLikeDAL
    {
        private readonly DataContext _context;

        public PostLikeDAL(DataContext context)
        {
            _context = context;
        }

        public IEnumerable<UserPostLikes> GetUsersWhoLikedPost(int id)
        {
            var users = _context.PostLikes.Where(x => x.PostID.Equals(id)).Include(x => x.UserData).ToList();

            List<UserPostLikes> listUsers = new List<UserPostLikes>();
            foreach (var item in users)
            {
                UserPostLikes singleUser = new UserPostLikes();

                singleUser.ID = item.ID;
                singleUser.Name = item.UserData.Name;
                singleUser.Photo = item.UserData.Photo;
                singleUser.Lastname = item.UserData.Lastname;
                singleUser.Eko = item.UserData.Eko;
                singleUser.Email = item.UserData.Email;
                listUsers.Add(singleUser);
            }
            return listUsers;
        }
    }
}
