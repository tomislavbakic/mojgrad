using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Functions;
using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL
{
    public class CommentsDAL : ICommentsDAL
    {
        private readonly DataContext _context;

        public CommentsDAL(DataContext context)
        {
            _context = context;
        }
        public ActionResult<string> CommentLike(CommentLike commentLike)
        {
            var existingComment = _context.CommentLikes.FirstOrDefault(x => x.CommentID == commentLike.CommentID && x.UserDataID == commentLike.UserDataID);

            if (existingComment == null)
            {
                try
                {


                    _context.CommentLikes.Add(commentLike);
                    _context.SaveChanges();

                    return "Like added";
                }
                catch (Exception)
                {

                    return "Wrong commentID or UserID";
                }

            }
            else
            {
                if(commentLike.LikeOrDislike == existingComment.LikeOrDislike)
                {
                    try
                    {

                        _context.CommentLikes.Remove(existingComment);
                        _context.SaveChanges();
                        return "Like removed";
                    }
                    catch (Exception)
                    {

                        return "Wrong commentID or UserID";
                    }

                }
                else
                {
                    try
                    {

                        existingComment.LikeOrDislike *= -1;
                        _context.CommentLikes.Update(existingComment);
                        _context.SaveChanges();
                        return "Like edited";
                    }

                    catch (Exception)
                    {

                        return "Wrong commentID or UserID";
                    }
                }
                

            }
        }

        public async Task<ActionResult<string>> DeleteComment(int id)
        {
            try
            {
                var comment = await _context.Comments.FindAsync(id);
                
                if (comment.CommentPhoto != null)
                {
                    ImageDelete imgDelete = new ImageDelete();
                    imgDelete.ImageDeleteURL(comment.CommentPhoto);
                }

                _context.Comments.Remove(comment);

                var notify = _context.Notifications.FirstOrDefault(x => x.NewThingID == id && x.TypeOfNotification == 3);
                if(notify != null)
                {
                    _context.Notifications.Remove(notify);
                }


                await _context.SaveChangesAsync();
                return "Comment deleted";
            }
            catch (Exception)
            {
                return "Failed to delete comment with that ID";
            }
        }

        public async Task<ActionResult<Comment>> PostComment(Comment comment)
        {
            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();

            Notification notify = new Notification();
            var comm = _context.Comments.Include(x => x.Post).Include(x => x.UserData).FirstOrDefault(x => x.ID == comment.ID);


            notify.UserID = comm.Post.UserDataID;
            notify.TypeOfNotification = 3; // newComment
            notify.isRead = false;
            notify.Title = comm.UserData.Name + " " + comm.UserData.Lastname + " je komentarisao/la Vašu objavu " + comm.Post.Title;
            //notify.Message = comm.UserData.Name + " " + comm.UserData.Lastname + " je komentarisao/la vasu objavu " + comm.Post.Title;
            notify.Message = DateTime.Now.ToString();
            notify.UserNotificationMakerID = comm.UserDataID;
            notify.NewThingID = comm.ID;
            notify.UserNotificationMakerPhoto = comm.UserData.Photo;
            notify.NotificationForID = comm.Post.ID;

            if (notify.UserID != notify.UserNotificationMakerID)
            {
                _context.Notifications.Add(notify);
            }
;
            await _context.SaveChangesAsync();

            return comment;

        }
    }
}
