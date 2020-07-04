using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Microsoft.Extensions.Configuration;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Authorization;
using Backend.UI.Interfaces;
using Backend.Models.ViewModels;

namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    
    public class UserDatasController : ControllerBase
    {
        private readonly DataContext _context;

        private IUserDatasUI _IUserDatasUI;

        public UserDatasController(DataContext context, IUserDatasUI IUserDatasUI)
        {
            _context = context;
            _IUserDatasUI = IUserDatasUI;
        }

        // GET: api/UserDatas
        [Authorize]
        [HttpGet]
        public ActionResult<IEnumerable<UserInfo>> GetUserDatasAsync()
        {
             return _IUserDatasUI.GettAllUserInfo();
        }

        [Authorize]
        [Route("topUsers")]
        [HttpGet]
        public ActionResult<IEnumerable<UserInfo>> GetTop10Users()
        {
            return _IUserDatasUI.GettTop10UserInfo();
        }

        [Authorize]
        [Route("blockedUsers")]
        [HttpGet]
        public ActionResult<IEnumerable<BlockedUserInfo>> GetBlockedUsers()
        {
            return _IUserDatasUI.GetBlockedUsers();
        }

        [Authorize]
        [Route("blockedUsers")]
        [HttpPost]
        public ActionResult<bool> AddBlockedUsers(BlockedUser blockedUser)
        {
            return _IUserDatasUI.AddBlockedUser(blockedUser);

        }

        [Authorize]
        [Route("blockedUsers/{id}")]
        [HttpDelete]
        public async Task<ActionResult<bool>> DeleteBlockedUsers(int id)
        {
            return await _IUserDatasUI.DeleteBlockedUser(id);
        }


        //funkciji treba poslati id user-a, a nazad se dobija UserInfo u kome se nalazi cityName i rankName (sa ostalim informacijama)
        [Authorize]
        [HttpGet("{id}")]
        public async Task<ActionResult<UserInfo>> GetUserDatasInfo(int id)
        {
            return await _IUserDatasUI.GetUserInfo(id);
            //return await _context.UserDatas.ToListAsync();
        }


        //------------------------------LOGIN TOKEN--------------------------

        [Route("login")]
        [HttpPost]
        public IActionResult Login(Login login)
        {
            IActionResult response = Unauthorized();

            var user = _IUserDatasUI.AuthenticateUser(login);

            //var user = AuthenticateUser(login);

            if (user != null)
            {
                string tokenStr = _IUserDatasUI.GenerateJSONWebToken(user);
                response = Ok(new { token = tokenStr });
            }
            return response;
        }



        //Check for email
        [Route("email")]
        [HttpPost]
        public async Task<ActionResult<bool>> ProveriEmail(UserEmail email)
        {
            var korisnici = await _context.UserDatas.ToListAsync();
            var korisnik = korisnici.Where(k => k.Email.Equals(email.Email)).FirstOrDefault();
            Console.WriteLine("sdasdasd" + korisnici.Count);
            if (korisnik == null)
                return false;
            return true;
        }

        [Authorize]
        [Route("changePassword")]
        [HttpPut]
        public  Task<bool> ChangeUserPassword(ChangePassword changePassword)
        {
            return _IUserDatasUI.TryToChangePassword(changePassword);
        }

        [Authorize]
        [Route("changeUserData")]
        [HttpPut]
        public Task<bool> ChangeUserData(UserChange userChange)
        {
            return _IUserDatasUI.ChangeUserData(userChange);
        }

        [Authorize]
        [Route("changeUserProfileImg")]
        [HttpPut]
        public Task<bool> ChangeUserProfileImg(ChangeUserProfileImg changeUserProfileImg)
        {
            return _IUserDatasUI.ChangeUserProfileImg(changeUserProfileImg);
        }

        [Route("register")]
        [HttpPost]
        public ActionResult<UserData> PostUserData(UserData userData)
        {
            _context.UserDatas.Add(userData);
            _context.SaveChanges();

            //return CreatedAtAction("GetUserData", new { id = userData.ID }, userData);
            return Ok();
        }

        [Authorize]
        [Route("deleteUser")]
        [HttpPost]
        public async Task<ActionResult<bool>> DeleteUser(UserDelete userDelete)
        {
            return await _IUserDatasUI.DeleteUser(userDelete);
        }

        [Authorize]
        [Route("reward")]
        [HttpPost]
        public string UserRewardAndCommentAwarded(RewardUser rewardUser)
        {
            return _IUserDatasUI.UserRewardAndCommentAwarded(rewardUser);
        }

        [Authorize]
        [Route("additionalData")]
        [HttpPut]
        public Task<bool> additionalData(UserAdditionalInfo uai)
        {
            return _IUserDatasUI.additionalData(uai);
        }

        //need to edit
        [Authorize]
        [Route("searchUsers")]
        [HttpPost]
        public List<UserInfo> UsersSearch(SearchUser searchUser)
        {
            
            return _IUserDatasUI.UsersSearch(searchUser);
        }

        [Authorize]
        [Route("addRating")]
        [HttpPost]
        public bool AddRating(Rating rating)
        {

            return _IUserDatasUI.AddRating(rating);
        }


        [Route("resetPassword/{email}")]
        [HttpPost]
        public bool ResetPassword(String email)
        {
            return _IUserDatasUI.ResetUserPassword(email);
        }

        [Authorize]
        [Route("userRating/{userID}")]
        [HttpGet]
        public int GetUserRating(int userID)
        {
            return _IUserDatasUI.GetUserRating(userID);
        }

    }

    

    public class UserEmail
    {
        public string Email {get;set;}
    }

}
