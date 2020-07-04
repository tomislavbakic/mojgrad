using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.BL.Interfaces
{
    public interface ICategoriesBL
    {
        public Task<ActionResult<IEnumerable<Category>>> GetCategories();
    }
}
