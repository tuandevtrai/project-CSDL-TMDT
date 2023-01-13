using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Controllers
{
    public class ChiTietXeController : Controller
    {
        QuanLyXeMayEntities data = new QuanLyXeMayEntities();
        // GET: ChiTietXe
        public ActionResult Index(int id)
        {
            return View(data.Xes.FirstOrDefault(x => x.MaXe == id));
        }

    }
}