using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection.Metadata;
using System.Threading.Tasks;
using Backend.Models.ViewModels;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using static System.Net.Mime.MediaTypeNames;


namespace Backend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImageUploadController : ControllerBase
    {
        public static IWebHostEnvironment _environment;

        public ImageUploadController(IWebHostEnvironment environment)
        {
            _environment = environment;
        }

        public class FileUploadAPI
        {
            public IFormFile files { get; set; }
        }

        public class FileUploadByetsAPI
        {
            public byte[] bytes { get; set; }
        }

        //route for user post
        [Route("postImage")]
        [HttpPost]
        public string PostImages([FromForm]FileUploadAPI objFile)
        {
            string path = "\\Upload\\Posts\\";
            try
            {
                if (objFile.files.Length > 0)
                {
                    /* if (!Directory.Exists(_environment.WebRootPath + path))
                     {
                         Directory.CreateDirectory(_environment.WebRootPath + path);
                     }*/
                    using (FileStream fileStream = System.IO.File.Create($"{_environment.ContentRootPath}/wwwroot/Upload/Posts/" + objFile.files.FileName))
                    {
                        objFile.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return path + objFile.files.FileName;
                    }
                }
                else
                {
                    return "Failed";
                }
            }
            catch (Exception ex)
            {

                return ex.Message.ToString();
            }

        }

        [Route("solutions")]
        [HttpPost]
        public string SolutionImages([FromForm]FileUploadAPI objFile)
        {
            string path = "\\Upload\\Solutions\\";
            try
            {
                if (objFile.files.Length > 0)
                {
                    /* if (!Directory.Exists(_environment.WebRootPath + path))
                     {
                         Directory.CreateDirectory(_environment.WebRootPath + path);
                     }*/
                    using (FileStream fileStream = System.IO.File.Create($"{_environment.ContentRootPath}/wwwroot/Upload/Solutions/" + objFile.files.FileName))
                    {
                        objFile.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return path + objFile.files.FileName;
                    }
                }
                else
                {
                    return "Failed";
                }
            }
            catch (Exception ex)
            {

                return ex.Message.ToString();
            }

        }

        //route for user profile photos
        [Route("userImage")]
        [HttpPost]
        public string UserProfile([FromForm]FileUploadAPI objFile)
        {
            //User profile photo
            string path = "\\Upload\\UserProfile\\";
            try
            {
                if (objFile.files.Length > 0)
                {
                    /*  if (!Directory.Exists(_environment.WebRootPath + path))
                      {
                          Directory.CreateDirectory(_environment.WebRootPath + path);
                      }*/
                    using (FileStream fileStream = System.IO.File.Create($"{_environment.ContentRootPath}/wwwroot/Upload/UserProfile/" + objFile.files.FileName))
                    {
                        objFile.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return path + objFile.files.FileName;
                    }
                }
                else
                {
                    return "Failed";
                }
            }
            catch (Exception ex)
            {

                return ex.Message.ToString();
            }

        }


        [Route("commentsImage")]
        [HttpPost]
        public string CommentsImage([FromForm]FileUploadAPI objFile)
        {
            //User profile photo
            string path = "\\Upload\\Comments\\";
            try
            {
                if (objFile.files.Length > 0)
                {
                    /* if (!Directory.Exists(_environment.WebRootPath + path))
                     {
                         Directory.CreateDirectory(_environment.WebRootPath + path);
                     }*/
                    using (FileStream fileStream = System.IO.File.Create($"{_environment.ContentRootPath}/wwwroot/Upload/Comments/" + objFile.files.FileName))
                    {
                        objFile.files.CopyTo(fileStream);
                        fileStream.Flush();
                        return path + objFile.files.FileName;
                    }
                }
                else
                {
                    return "Failed";
                }
            }
            catch (Exception ex)
            {
                return ex.Message.ToString();
            }

        }

        [Route("webImageUpload")]
        [HttpPost]
        public string ImageUpload(WebImage webImage)
        {

            if (webImage.img != null || webImage.img != "")
            {
                byte[] bytes = Convert.FromBase64String(webImage.img);
                var path = webImage.route + Guid.NewGuid() + ".jpg";
                var filePath = Path.Combine($"{_environment.ContentRootPath}/wwwroot/" + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return path;
            }
            return "";
        }

        [Route("test")]
        [HttpPost]
        public string Test(WebImage webImage)
        {
            /*var pic = Convert.ToBase64String(objFile.bytes);
            string path = "\\Upload\\Posts\\";

            var base64array = Convert.FromBase64String(pic);
            //var filePath = Path.Combine($"{_environment.ContentRootPath}/wwwroot/Upload/Ranks/{Guid.NewGuid()}.jpg");
            //System.IO.File.WriteAllBytes(filePath, base64array);
            */
            if (webImage.img != null || webImage.img != "")
            {
                byte[] bytes = Convert.FromBase64String(webImage.img);
                //var ext = "img";
                //var fullpath = Constant.ImagesRoot + DateTime.Now.ToString("yyyyMMddHHmmssfff") + "." + ext; 
                var path = "Upload//Ranks//" + Guid.NewGuid() + ".jpg";
                var filePath = Path.Combine($"{_environment.ContentRootPath}/wwwroot/" + path);
                System.IO.File.WriteAllBytes(filePath, bytes);
                return path;
            }

            return "";

        }
    }
}
