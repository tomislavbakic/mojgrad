using Backend.Controllers;
using Backend.DAL.Interfaces;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public class UserDatasBL : IUserDatasBL
    {
        private readonly IUserDatasDAL _IUserDatasDAL;
        private IConfiguration _config;

        public UserDatasBL(IUserDatasDAL IUserDatasDAL, IConfiguration config)
        {
            _IUserDatasDAL = IUserDatasDAL;
            _config = config;
        }

        public UserDatasBL(IUserDatasDAL IUserDatasDAL)
        {
            _IUserDatasDAL = IUserDatasDAL;
        }
        public UserData AuthenticateUser(Login login)
        {
            return _IUserDatasDAL.AuthenticateUser(login);
        }

        public string GenerateJSONWebToken(UserData user)
        {
            var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_config["Jwt:Key"]));
            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                new Claim(JwtRegisteredClaimNames.NameId, user.ID.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti,Guid.NewGuid().ToString())
            };

            var token = new JwtSecurityToken(
                issuer: _config["Jwt:Issuer"],
                audience: _config["Jwt:Issuer"],
                claims,
                expires: DateTime.Now.AddMinutes(1440),
                signingCredentials: credentials);

            var encodeToken = new JwtSecurityTokenHandler().WriteToken(token);
            return encodeToken;
        }

        public Task<ActionResult<UserInfo>> GetUserInfo(int id)
        {
            return _IUserDatasDAL.GetUserInfo(id);
        }

        public ActionResult<IEnumerable<UserInfo>> GettAllUserInfo()
        {
            return _IUserDatasDAL.GettAllUserInfo();
        }

        public ActionResult<IEnumerable<UserInfo>> GettTop10UserInfo()
        {
            return _IUserDatasDAL.GettTop10UserInfo();
        }

        public Task<bool> TryToChangePassword(ChangePassword changePassword)
        {
            return _IUserDatasDAL.TryToChangePassword(changePassword);
        }

        public Task<bool> ChangeUserData(UserChange userChange)
        {
            return _IUserDatasDAL.ChangeUserData(userChange);
        }

        public Task<bool> ChangeUserProfileImg(ChangeUserProfileImg changeUserProfileImg)
        {
            return _IUserDatasDAL.ChangeUserProfileImg(changeUserProfileImg);
        }

        public Task<ActionResult<bool>> DeleteUser(UserDelete userDelete)
        {
            return _IUserDatasDAL.DeleteUser(userDelete);
        }

        public ActionResult<IEnumerable<BlockedUserInfo>> GetBlockedUsers()
        {
            return _IUserDatasDAL.GetBlockedUsers();
        }

        public ActionResult<bool> AddBlockedUser(BlockedUser blockedUser)
        {
            return _IUserDatasDAL.AddBlockedUser(blockedUser);
        }

        public Task<ActionResult<bool>> DeleteBlockedUser(int id)
        {
            return _IUserDatasDAL.DeleteBlockedUser(id);
        }

        public string UserRewardAndCommentAwarded(RewardUser rewardUser)
        {
            return _IUserDatasDAL.UserRewardAndCommentAwarded(rewardUser);
        }

        public Task<bool> additionalData(UserAdditionalInfo uai)
        {
            return _IUserDatasDAL.additionalData(uai);
        }

        public List<UserInfo> UsersSearch(SearchUser searchUser)
        {
            return _IUserDatasDAL.UsersSearch(searchUser);
        }

        public bool AddRating(Rating rating)
        {
            return _IUserDatasDAL.AddRating(rating);
        }

        public bool ResetUserPassword(string email)
        {
            return _IUserDatasDAL.ResetUserPassword(email);
        }
        public int GetUserRating(int userID)
        {
            return _IUserDatasDAL.GetUserRating(userID);
        }
    }
}
