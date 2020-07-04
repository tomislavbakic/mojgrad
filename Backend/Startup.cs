using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Backend.BL;
using Backend.BL.Interfaces;
using Backend.DAL;
using Backend.DAL.Interfaces;
using Backend.Data;
using Backend.Models;
using Backend.UI;
using Backend.UI.Interfaces;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;


namespace Backend
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            //services.AddCors();
            services.AddDbContext<DataContext>();
            
            services.AddTransient<IPostsUI, PostsUI>();
            services.AddTransient<IPostsBL, PostsBL>();
            services.AddTransient<IPostsDAL, PostsDAL>();

            services.AddTransient<IUserDatasUI, UserDatasUI>();
            services.AddTransient<IUserDatasBL, UserDatasBL>();
            services.AddTransient<IUserDatasDAL, UserDatasDAL>();

            services.AddTransient<IAdminsUI, AdminsUI>();
            services.AddTransient<IAdminsBL, AdminsBL>();
            services.AddTransient<IAdminsDAL, AdminsDAL>();

            services.AddTransient<ICategoriesUI, CategoriesUI>();
            services.AddTransient<ICategoriesBL, CategoriesBL>();
            services.AddTransient<ICategoriesDAL, CategoriesDAL>();

            services.AddTransient<ICommentsUI, CommentsUI>();
            services.AddTransient<ICommentsBL, CommentsBL>();
            services.AddTransient<ICommentsDAL, CommentsDAL>();

            services.AddTransient<IPostReportUI, PostReportUI>();
            services.AddTransient<IPostReportBL, PostReportBL>();
            services.AddTransient<IPostReportDAL, PostReportDAL>();

            services.AddTransient<IPostLikeUI, PostLikeUI>();
            services.AddTransient<IPostLikeBL, PostLikeBL>();
            services.AddTransient<IPostLikeDAL, PostLikeDAL>();

            services.AddTransient<IFeedbacksUI, FeedbacksUI>();
            services.AddTransient<IFeedbacksBL, FeedbacksBL>();
            services.AddTransient<IFeedbacksDAL, FeedbacksDAL>();

            services.AddTransient<ICommentReportsUI, CommentReportsUI>();
            services.AddTransient<ICommentReportsBL, CommentReportsBL>();
            services.AddTransient<ICommentReportsDAL, CommentReportsDAL>();

            services.AddTransient<IUserReportsUI, UserReportsUI>();
            services.AddTransient<IUserReportsBL, UserReportsBL>();
            services.AddTransient<IUserReportsDAL, UserReportsDAL>();

            services.AddTransient<IOrganisationsUI, OrganisationsUI>();
            services.AddTransient<IOrganisationsBL, OrganisationsBL>();
            services.AddTransient<IOrganisationsDAL, OrganisationsDAL>();

            services.AddTransient<IRanksUI, RanksUI>();
            services.AddTransient<IRanksBL, RanksBL>();
            services.AddTransient<IRanksDAL, RanksDAL>();

            services.AddTransient<IOrganisationPostsUI, OrganisationPostsUI>();
            services.AddTransient<IOrganisationPostsBL, OrganisationPostsBL>();
            services.AddTransient<IOrganisationPostsDAL, OrganisationPostsDAL>();

            //----------------------ZA TOKEN----------------------
            /* services.AddCors(options =>
             {
                 options.AddPolicy("CorsPolicy", builder => builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader().AllowCredentials().Build());
             });*/

            services.AddCors(o => o.AddPolicy("MyPolicy", builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            }));

            services.AddControllers().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
                .AddJwtBearer(options =>
                {
                    options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
                    {
                        ValidateIssuer = true,
                        ValidateAudience = true,
                        ValidateLifetime = true,
                        ValidateIssuerSigningKey = true,
                        ValidIssuer = Configuration["Jwt:Issuer"],
                        ValidAudience = Configuration["Jwt:Issuer"],
                        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
                    };
                });
            services.AddMvc();
            //----------------------KRAJ TOKENA----------------------
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseCors("MyPolicy");

            app.UseRouting();

            app.UseAuthentication();

            app.UseAuthorization();

            //file
            app.UseStaticFiles();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
