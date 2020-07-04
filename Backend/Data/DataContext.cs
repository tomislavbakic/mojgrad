using Backend.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Data
{
    public class DataContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlite(@"Data Source = mojgrad.db;");

        }

        public DbSet<Category> Categories { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<Post> Posts { get; set; }
        public DbSet<UserData> UserDatas { get; set; }
        public DbSet<Backend.Models.Admin> Admins { get; set; }
        public DbSet<Rank> Ranks { get; set; }
        public DbSet<PostLike> PostLikes { get; set; }
        public DbSet<PostImage> PostImages { get; set; }
        public DbSet<PostReport> PostReports { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<CommentImage> CommentImages { get; set; }
        public DbSet<CommentLike> CommentLikes { get; set; }
        public DbSet<CommentReport> CommentReports { get; set; }
        public DbSet<Feedback> Feedbacks { get; set; }
        public DbSet<BlockedUser> BlockedUsers { get; set; }
        public DbSet<Location> Location { get; set; }
        public DbSet<UserReport> UserReports { get; set; }
        public DbSet<Backend.Models.Organisation> Organisations { get; set; }
        public DbSet<Backend.Models.OrganisationPost> OrganisationPosts { get; set; }
        public DbSet<SavedPost> SavedPosts { get; set; }
        public DbSet<PostSolution> PostSolutions { get; set; }
        public DbSet<SolutionLike> SolutionLikes { get; set; }
        public DbSet<SolutionReport> SolutionReports { get; set; }
        public DbSet<Rating> Ratings { get; set; }
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<OrganisationPostLike> OrganisationPostLikes { get; set; }
        

        //public DbSet<Location> Locations { get; set; }
    }
    public static class LinqExtensions
    {
        public static IEnumerable<T> DistinctBy<T, TKey>(this IEnumerable<T> items, Func<T, TKey> property)
        {
            GeneralPropertyComparer<T, TKey> comparer = new GeneralPropertyComparer<T, TKey>(property);
            return items.Distinct(comparer);
        }
    }
    public class GeneralPropertyComparer<T, TKey> : IEqualityComparer<T>
    {
        private Func<T, TKey> expr { get; set; }
        public GeneralPropertyComparer(Func<T, TKey> expr)
        {
            this.expr = expr;
        }
        public bool Equals(T left, T right)
        {
            var leftProp = expr.Invoke(left);
            var rightProp = expr.Invoke(right);
            if (leftProp == null && rightProp == null)
                return true;
            else if (leftProp == null ^ rightProp == null)
                return false;
            else
                return leftProp.Equals(rightProp);
        }
        public int GetHashCode(T obj)
        {
            var prop = expr.Invoke(obj);
            return (prop == null) ? 0 : prop.GetHashCode();
        }
    }


}
