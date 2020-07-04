using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Models
{
    public class Notification
    {
        public int ID { get; set; }
        public int UserID { get; set; }

        //{ rankUP = 1, newPostLike = 2, newComment = 3, newSolution = 4, myRewardedSolution = 5}

        // Kad neko odlikuje, brise se notifikacija, isto vazi i za comment i solution
        // to do 
        public int TypeOfNotification { get; set; }
        public bool isRead { get; set; }
        public string Message { get; set; }
        public int UserNotificationMakerID { get; set; }
        public string UserNotificationMakerPhoto { get; set; }
        public int NewThingID { get; set; }
        public string Title { get; set; }
        public int NotificationForID { get; set; }
    }
}
