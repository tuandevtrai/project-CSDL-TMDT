using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Areas.Admin.Controllers
{
    public class AdminLoginController : Controller
    {

        QuanLyXeMayEntities data = new QuanLyXeMayEntities();   

        // GET: Admin/AdminLogin
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult LoginAdmin(XeMayShop.Models.Admin admin)
        {            
            List<XeMayShop.Models.Admin> check = data.sp_CheckLogin(admin.TenDangNhap, admin.MatKhau).ToList();

            if (check.Count == 0)
            {
                ViewBag.ErrorInfo = "Sai thông tin tài khoản";
                return View("Index");
            }
            else
            {
                Session["Admin"] = check[0];

                return RedirectToAction("Index", "AdminHome", new { Areas = "Admin" });
            }
        }
    }
}