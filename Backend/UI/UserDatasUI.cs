using Backend.BL.Interfaces;
using Backend.Controllers;
using Backend.Models;
using Backend.Models.ViewModels;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI
{
    public class UserDatasUI : IUserDatasUI
    {
        private readonly IUserDatasBL _IUserDatasBL;

        public UserDatasUI(IUserDatasBL IUserDatasBL)
        {
            _IUserDatasBL = IUserDatasBL;
        }

        public string GenerateJSONWebToken(UserData user)
        {
            return _IUserDatasBL.GenerateJSONWebToken(user);
        }

        public ActionResult<IEnumerable<UserInfo>> GettAllUserInfo()
        {
            return _IUserDatasBL.GettAllUserInfo();
        }
        public ActionResult<IEnumerable<UserInfo>> GettTop10UserInfo()
        {
            return _IUserDatasBL.GettTop10UserInfo();
        }

        public Task<ActionResult<UserInfo>> GetUserInfo(int id)
        {
            return _IUserDatasBL.GetUserInfo(id);
        }

        UserData IUserDatasUI.AuthenticateUser(Login login)
        {
            return _IUserDatasBL.AuthenticateUser(login);
        }

        public Task<bool> TryToChangePassword(ChangePassword changePassword)
        {
            return _IUserDatasBL.TryToChangePassword(changePassword);
        }

        public Task<bool> ChangeUserData(UserChange userChange)
        {
            return _IUserDatasBL.ChangeUserData(userChange);
        }

        public Task<bool> ChangeUserProfileImg(ChangeUserProfileImg changeUserProfileImg)
        {
            return _IUserDatasBL.ChangeUserProfileImg(changeUserProfileImg);
        }

        public Task<ActionResult<bool>> DeleteUser(UserDelete userDelete)
        {
            return _IUserDatasBL.DeleteUser(userDelete);
        }

        public ActionResult<IEnumerable<BlockedUserInfo>> GetBlockedUsers()
        {
            return _IUserDatasBL.GetBlockedUsers();
        }

        public ActionResult<bool> AddBlockedUser(BlockedUser blockedUser)
        {
            return _IUserDatasBL.AddBlockedUser(blockedUser);
        }

        public Task<ActionResult<bool>> DeleteBlockedUser(int id)
        {
            return _IUserDatasBL.DeleteBlockedUser(id);
        }

        public string UserRewardAndCommentAwarded(RewardUser rewardUser)
        {
            return _IUserDatasBL.UserRewardAndCommentAwarded(rewardUser);
        }

        public Task<bool> additionalData(UserAdditionalInfo uai)
        {
            return _IUserDatasBL.additionalData(uai);
        }

        public List<UserInfo> UsersSearch(SearchUser searchUser)
        {
            return _IUserDatasBL.UsersSearch(searchUser);
        }

        public bool AddRating(Rating rating)
        {
            return _IUserDatasBL.AddRating(rating);
        }

        public bool ResetUserPassword(string email)
        {
            return _IUserDatasBL.ResetUserPassword(email);
        }

        public int GetUserRating(int userID)
        {
            return _IUserDatasBL.GetUserRating(userID);
        }
    }
}
