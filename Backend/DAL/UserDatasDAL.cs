using Backend.Controllers;
using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Functions;
using Backend.Models;
using Backend.Models.ViewModels;
using MailKit.Net.Smtp;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MimeKit;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class UserDatasDAL : IUserDatasDAL
    {
        private readonly DataContext _context;

        public UserDatasDAL(DataContext context)
        {
            _context = context;
        }
        public UserData AuthenticateUser(Login login)
        {
            var existingUser = _context.UserDatas.
                Where(k => k.Email.Equals(login.Email)
                    && k.Password.Equals(login.Password)).FirstOrDefault();
            return existingUser;
        }

        public List<UserInfo> GettAllUserInfoFunction()
        {


            var users = _context.UserDatas.Include(x => x.City).Include(x => x.Rank).Include(x => x.Comments).Include(x => x.Posts).Include(x => x.BlockedUsers).ToList();


            List<UserInfo> listUserInfo = new List<UserInfo>();

            foreach (var item in users)
            {
                UserInfo uf = new UserInfo();

                uf.ID = item.ID;
                uf.Name = item.Name;
                uf.Lastname = item.Lastname;
                uf.Email = item.Email;
                uf.CityID = item.City.ID;
                uf.RankID = item.Rank.ID;
                uf.Photo = item.Photo;
                uf.RankName = item.Rank.Name;
                uf.CityName = item.City.Name;
                uf.RankImage = item.Rank.UrlPath;
                uf.PostsNumber = _context.Posts.Count(x => x.UserDataID == item.ID);
                uf.CommentsNumber = _context.PostSolutions.Where(x => x.UserID == item.ID && x.UserType == 1 && x.isAwarded == 1).Count();
                uf.Age = item.Age;
                uf.Gender = item.Gender;
                // eko points = liked posts by other users + like comments by other users - disliked comments by other users
                uf.Eko = _context.PostLikes.Where(x => x.PostID == x.Post.ID && x.Post.UserDataID == item.ID && x.Post.UserDataID != x.UserDataID).Count()
                    + _context.CommentLikes.Where(x => x.CommentID == x.Comment.ID && x.Comment.UserDataID == item.ID && x.Comment.UserDataID != x.UserDataID && x.LikeOrDislike == 1).Count()
                    - _context.CommentLikes.Where(x => x.CommentID == x.Comment.ID && x.Comment.UserDataID == item.ID && x.Comment.UserDataID != x.UserDataID && x.LikeOrDislike == -1).Count()
                    + _context.SolutionLikes.Where(x => x.PostSolution.UserID == item.ID && x.PostSolution.UserID != x.UserDataID && x.PostSolution.UserType == 1 && x.LikeOrDislike == 1).Count()
                    - _context.SolutionLikes.Where(x => x.PostSolution.UserID == item.ID && x.PostSolution.UserID != x.UserDataID && x.PostSolution.UserType == 1 && x.LikeOrDislike == -1).Count()
                    + item.Eko;

                if (uf.Eko < 0)
                    uf.Eko = 0;

                var rankID = _context.Ranks.FirstOrDefault(x => uf.Eko >= x.MinPoints && uf.Eko <= x.MaxPoints).ID;
                if (uf.RankID != rankID)
                {
                    uf.RankID = rankID;
                    item.RankID = rankID;
                    _context.UserDatas.Update(item);
                    _context.SaveChanges();
                }


                var isBlocked = item.BlockedUsers.FirstOrDefault(x => x.UserDataID == item.ID);
                if (isBlocked == null)
                    uf.isBlocked = 0;
                else
                    uf.isBlocked = 1;

                uf.CommentReportsNumber = _context.CommentReports.Where(x => x.Comment.UserDataID == item.ID).Count();
                uf.PostReportsNumber = _context.PostReports.Where(x => x.Post.UserDataID == item.ID).Count();
                uf.UserReportsNumber = _context.UserReports.Where(x => x.ReportedUserID == item.ID).Count();
                uf.AllReportsNumber = uf.CommentReportsNumber + uf.PostReportsNumber + uf.UserReportsNumber;

                listUserInfo.Add(uf);
            }


            return listUserInfo;
        }

        public ActionResult<IEnumerable<UserInfo>> GettTop10UserInfo()
        {
            var users = GettAllUserInfoFunction();
            users = users.OrderByDescending(x => x.Eko).ToList();
            users = users.Take(10).ToList();
            return users;
        }

        public ActionResult<IEnumerable<UserInfo>> GettAllUserInfo()
        {
            return GettAllUserInfoFunction();
        }

        public async Task<ActionResult<UserInfo>> GetUserInfo(int id)
        {
            UserInfo uf = new UserInfo();

            var users = await _context.UserDatas.Include(x => x.City).Include(x => x.Rank).Include(x => x.Comments).Include(x => x.Posts).Include(x => x.BlockedUsers).ToListAsync();

            if(users == null)
            {
                return null;
            }

            var userWithID = users.FirstOrDefault(x => x.ID == id);
            var cityName = _context.Cities.FirstOrDefault(x => x.ID == userWithID.City.ID).Name;
            var rankName = _context.Ranks.FirstOrDefault(x => x.ID == userWithID.Rank.ID).Name;

            uf.ID = userWithID.ID;
            uf.Name = userWithID.Name;
            uf.Lastname = userWithID.Lastname;
            uf.Email = userWithID.Email;
            uf.CityID = userWithID.City.ID;
            uf.RankID = userWithID.Rank.ID;
            uf.Photo = userWithID.Photo;
            uf.RankName = rankName;
            uf.CityName = cityName;
            uf.RankImage = userWithID.Rank.UrlPath;
            uf.PostsNumber = _context.Posts.Count(x => x.UserDataID == id);
            uf.CommentsNumber = _context.PostSolutions.Where(x => x.UserID == userWithID.ID && x.UserType == 1 && x.isAwarded == 1).Count();
            uf.Age = userWithID.Age;
            uf.Gender = userWithID.Gender;
            // eko points = liked posts by other users + like comments by other users - disliked comments by other users
            uf.Eko = _context.PostLikes.Where(x => x.PostID == x.Post.ID && x.Post.UserDataID == userWithID.ID && x.Post.UserDataID != x.UserDataID).Count()
                + _context.CommentLikes.Where(x => x.CommentID == x.Comment.ID && x.Comment.UserDataID == userWithID.ID && x.Comment.UserDataID != x.UserDataID && x.LikeOrDislike == 1).Count()
                - _context.CommentLikes.Where(x => x.CommentID == x.Comment.ID && x.Comment.UserDataID == userWithID.ID && x.Comment.UserDataID != x.UserDataID && x.LikeOrDislike == -1).Count()
                + _context.SolutionLikes.Where(x => x.PostSolution.UserID == userWithID.ID && x.PostSolution.UserID != x.UserDataID && x.PostSolution.UserType == 1 && x.LikeOrDislike == 1).Count()
                - _context.SolutionLikes.Where(x => x.PostSolution.UserID == userWithID.ID && x.PostSolution.UserID != x.UserDataID && x.PostSolution.UserType == 1 && x.LikeOrDislike == -1).Count()
                + userWithID.Eko;

            if (uf.Eko < 0)
                uf.Eko = 0;

            var rankID = _context.Ranks.FirstOrDefault(x => uf.Eko >= x.MinPoints && uf.Eko <= x.MaxPoints).ID;
            if (uf.RankID != rankID)
            {
                uf.RankID = rankID;
                userWithID.RankID = rankID;
                _context.UserDatas.Update(userWithID);
                _context.SaveChanges();
            }

            var isBlocked = userWithID.BlockedUsers.FirstOrDefault(x => x.UserDataID == id);
            if (isBlocked == null)
                uf.isBlocked = 0;
            else
                uf.isBlocked = 1;

            uf.CommentReportsNumber = _context.CommentReports.Where(x => x.Comment.UserDataID == userWithID.ID).Count();
            uf.PostReportsNumber = _context.PostReports.Where(x => x.Post.UserDataID == userWithID.ID).Count();
            uf.UserReportsNumber = _context.UserReports.Where(x => x.ReportedUserID == userWithID.ID).Count();
            uf.AllReportsNumber = uf.CommentReportsNumber + uf.PostReportsNumber + uf.UserReportsNumber;

            return uf;

        }

        public async Task<bool> TryToChangePassword(ChangePassword changePassword)
        {
            var user = await _context.UserDatas.FirstOrDefaultAsync(x => x.ID == changePassword.ID);

            if (user.Password == changePassword.OldPassword)
            {
                user.Password = changePassword.NewPassword;

                _context.UserDatas.Update(user);

                _context.SaveChanges();

                return true;
            }
            else
            {
                return false;
            }
        }

        public async Task<bool> ChangeUserData(UserChange userChange)
        {

            try
            {
                var user = await _context.UserDatas.FirstOrDefaultAsync(x => x.ID == userChange.Id);

                user.Name = userChange.NewName;
                user.Lastname = userChange.NewLastname;
                user.Email = userChange.NewEmail;
                user.Age = userChange.NewAge;
                user.CityID = userChange.NewCityID;

                _context.UserDatas.Update(user);

                _context.SaveChanges();

                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }

        public async Task<bool> ChangeUserProfileImg(ChangeUserProfileImg changeUserProfileImg)
        {
            try
            {
                var user = await _context.UserDatas.FirstOrDefaultAsync(x => x.ID == changeUserProfileImg.id);

                
                if(user.Photo != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(user.Photo);
                }
                

                user.Photo = changeUserProfileImg.photo;

                

                _context.UserDatas.Update(user);

                _context.SaveChanges();

                return true;
            }
            catch (Exception e)
            {

                return false;
            }
        }

        public async Task<ActionResult<bool>> DeleteUser(UserDelete userDelete)
        {
            var user = await _context.UserDatas.FirstOrDefaultAsync(x => x.ID == userDelete.ID);
            if (user == null)
                return false;

            if (user.Password != userDelete.Password)
                return false;

            try
            {
                if (user.Photo != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(user.Photo);
                }
                _context.UserDatas.Remove(user);

                var solForDelete = _context.PostSolutions.Where(x => x.UserType == 1 && x.UserID == user.ID);
                foreach (var item in solForDelete)
                {
                    _context.PostSolutions.Remove(item);
                }

                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception e)
            {

                return false;
            }


        }

        public ActionResult<IEnumerable<BlockedUserInfo>> GetBlockedUsers()
        {
            var blockedUsers = _context.BlockedUsers.Include(x => x.UserData).ToList();

            List<BlockedUserInfo> listBlockedUsers = new List<BlockedUserInfo>();

            foreach (var item in blockedUsers)
            {
                BlockedUserInfo bui = new BlockedUserInfo();

                bui.ID = item.ID;
                bui.UserID = item.UserDataID;
                bui.Reason = item.Reason;
                bui.BlockedUntil = item.BlockedUntil;
                bui.Fullname = item.UserData.Name + " " + item.UserData.Lastname;
                bui.Photo = item.UserData.Photo;

                listBlockedUsers.Add(bui);

            }

            return listBlockedUsers;
        }

        public ActionResult<bool> AddBlockedUser(BlockedUser blockedUser)
        {

            var user = _context.BlockedUsers.FirstOrDefault(x => x.UserDataID == blockedUser.UserDataID);

            try
            {
                if(user == null)
                {
                    _context.BlockedUsers.Add(blockedUser);
                    _context.SaveChanges();
                    return true;
                }
                else
                {
                    user.BlockedUntil = blockedUser.BlockedUntil;
                    _context.BlockedUsers.Update(user);
                    _context.SaveChanges();
                    return true;
                }
            }
            catch (Exception)
            {

                return false;
            }
        }

        public async Task<ActionResult<bool>> DeleteBlockedUser(int id)
        {
            var user = await _context.BlockedUsers.FirstOrDefaultAsync(x => x.UserDataID == id);
            if (user == null)
                return false;

            try
            {
                _context.BlockedUsers.Remove(user);
                await _context.SaveChangesAsync();
                return true;
            }
            catch (Exception)
            {

                return false;
            }
        }

        public string UserRewardAndCommentAwarded(RewardUser rewardUser)
        {
            PostSolution solution = _context.PostSolutions.Include(x => x.Post).Where(x => x.ID.Equals(rewardUser.SolutionID)).FirstOrDefault();

            solution.isAwarded = 1; //comment awarded!!!



            int userID = solution.UserID;

            UserData user = _context.UserDatas.Where(x => x.ID.Equals(userID)).FirstOrDefault();

            user.Eko += rewardUser.Prize;

            _context.UserDatas.Update(user);
            _context.PostSolutions.Update(solution);

            Notification notify = new Notification();


            notify.UserID = solution.UserID;
            notify.TypeOfNotification = 5; //myRewardedSolution = 5
            notify.isRead = false;
            if (solution.UserType == 1) // user 1, org 2
            {
                var userPom = _context.UserDatas.FirstOrDefault(x => x.ID == solution.UserID);


                notify.Title = "Vaše resenje " + solution.Text + " je nagrađeno ";
                //notify.Message = "Vase resenje " + solution.Text + " je nagradjeno "; 
                notify.Message = DateTime.Now.ToString();
                notify.UserNotificationMakerPhoto = userPom.Photo;

            }
            else if (solution.UserType == 2)
            {
                var org = _context.Organisations.FirstOrDefault(x => x.ID == solution.UserID);

                notify.Title = "Vaše resenje " + solution.Text + " je nagrađeno "; 
                //notify.Message = "Vase resenje " + solution.Text + " je nagradjeno ";
                notify.Message = DateTime.Now.ToString();
                notify.UserNotificationMakerPhoto = org.ImagePath;

            }
            notify.NewThingID = solution.ID;
            notify.UserNotificationMakerID = solution.Post.UserDataID;

            notify.NotificationForID = solution.Post.ID;

            if (notify.UserID != notify.UserNotificationMakerID && solution.UserType == 1)
            {
                _context.Notifications.Add(notify);
            }
            if(solution.UserType == 2)
            {
                _context.Notifications.Add(notify);
            }
           
            _context.SaveChanges();

            return "true";
        }

        public async Task<bool> additionalData(UserAdditionalInfo uai)
        {
            try
            {
                var user = await _context.UserDatas.FirstOrDefaultAsync(x => x.ID == uai.userID);

                user.Gender = uai.Gender;
                user.Age = uai.Age;
                user.CityID = uai.CityID;

                _context.UserDatas.Update(user);
                _context.SaveChanges();

                return true;
            }
            catch (Exception)
            {

                return false;
            }

        }

        public List<UserInfo> UsersSearch(SearchUser searchUser)
        {
            var search = searchUser.Search.ToLower();

            var users = GettAllUserInfoFunction();
            users = users.Where(x => x.Name.ToLower().Contains(search) || x.Lastname.ToLower().Contains(search) || (x.Name.ToLower() + " " + x.Lastname.ToLower()).Contains(search) || (x.Lastname.ToLower() + " " + x.Name.ToLower()).Contains(search)).ToList();

            return users;
        }

        public bool AddRating(Rating rating)
        {

            var existingRating = _context.Ratings.FirstOrDefault(x => x.UserDataID == rating.UserDataID);

            try
            {


                if (existingRating == null)
                {
                    _context.Ratings.Add(rating);
                    _context.SaveChanges();
                    return true;
                }
                else
                {
                    existingRating.Grade = rating.Grade;
                    _context.Ratings.Update(existingRating);
                    _context.SaveChanges();
                    return true;
                }
            }
            catch (Exception)
            {

                return false;
            }

        }

        public List<Notification> AllNotifications(int userID)
        {
            return _context.Notifications.Where(x => x.UserID == userID).ToList();
        }


        public bool ResetUserPassword(String email)
        {
            UserData user = _context.UserDatas.Where(x => x.Email.Equals(email)).FirstOrDefault();
            RandomPasswordGenerator rpg = new RandomPasswordGenerator();
            if (user != null)
            {
                
                string password = rpg.GeneratePassword(true, true, true, 10);

                var message = new MimeMessage();
                message.From.Add(new MailboxAddress("Moj grad", "mojgrad.srb@gmail.com"));
                message.To.Add(new MailboxAddress("Moj grad", user.Email));
                message.Subject = "Moj grad - nova lozinka";
                message.Body = new TextPart("plain")
                {
                    Text = "Na Vaš zahtev, šaljemo Vam novu lozinku kojom možete da pristupite nalogu na aplikaciji Moj grad!\n" +
                    "lozinka: " + password + "\n\n\nHvala Vam što koristite našu aplikaciju."
                };
                using (var client = new SmtpClient())
                {
                    client.Connect("smtp.gmail.com", 587, false);
                    client.Authenticate("mojgrad.srb@gmail.com", "mojgrad123");
                    client.Send(message);
                    client.Disconnect(true);
                }

                String newPassword = rpg.Hash(password);

                user.Password = newPassword;
                _context.UserDatas.Update(user);
                _context.SaveChanges();

                //successful
                return true;
            }

            //user doesn't exist
            return false;

        }

        public int GetUserRating(int userID)
        {
            var rating = _context.Ratings.FirstOrDefault(x => x.UserDataID == userID);

            if (rating == null)
            {
                return -1;
            }
            else
            {
                return rating.Grade;
            }
        }
    }
}
