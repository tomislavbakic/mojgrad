using Backend.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Backend.UI.Interfaces
{
    public interface ICategoriesUI
    {
        public Task<ActionResult<IEnumerable<Category>>> GetCategories();
    }
}
