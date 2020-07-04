using Backend.Controllers;
using Backend.Models;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface IUserDatasDAL
    {
        UserData AuthenticateUser(Login login);
        Task<ActionResult<UserInfo>> GetUserInfo(int id);
        ActionResult<IEnumerable<UserInfo>> GettAllUserInfo();
        ActionResult<IEnumerable<UserInfo>> GettTop10UserInfo();
        Task<bool> TryToChangePassword(ChangePassword changePassword);
        Task<bool> ChangeUserData(UserChange userChange);
        Task<bool> ChangeUserProfileImg(ChangeUserProfileImg changeUserProfileImg);
        Task<ActionResult<bool>> DeleteUser(UserDelete userDelete);
        ActionResult<IEnumerable<BlockedUserInfo>> GetBlockedUsers();
        ActionResult<bool> AddBlockedUser(BlockedUser blockedUser);
        Task<ActionResult<bool>> DeleteBlockedUser(int id);
        string UserRewardAndCommentAwarded(RewardUser rewardUser);
        Task<bool> additionalData(UserAdditionalInfo uai);
        public List<UserInfo> UsersSearch(SearchUser searchUser);
        bool AddRating(Rating rating);
        public bool ResetUserPassword(String email);
        public int GetUserRating(int userID);

    }
}
