using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.Functions
{
    public class ImageDelete
    {
        public ImageDelete()
        {

        }
        public void ImageDeleteURL(string imgUrl)
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", imgUrl);

            if (System.IO.File.Exists(path) && !(imgUrl.Contains("default")))
            {
                System.IO.File.Delete(path);
            }

        }
            

        
    }
}
