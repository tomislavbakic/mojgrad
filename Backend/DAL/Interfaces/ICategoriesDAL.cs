using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.DAL.Interfaces
{
    public interface ICategoriesDAL
    {
        public Task<ActionResult<IEnumerable<Category>>> GetCategories();
    }
}
