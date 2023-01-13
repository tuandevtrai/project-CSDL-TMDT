using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace XeMayShop.Models
{
    public class XeDaDat
    {
        public Xe xeduocdat { get; set; }
        public int _soLuongHang { get; set; }
    }
    public class XeDat
    {
        List<XeDaDat> listXe = new List<XeDaDat>();
        public IEnumerable<XeDaDat> ListXe
        {
            get { return listXe; }
        }

        public void Add(Xe _xe, int _soluong = 1)
        {
            var i = listXe.FirstOrDefault(s => s.xeduocdat.MaXe == _xe.MaXe);
            if(i == null)
            {
                listXe.Add(new XeDaDat
                {
                    xeduocdat = _xe,
                    _soLuongHang = _soluong
                });
            }
            else
            {
                i._soLuongHang += _soluong;
            }
        }

        public void update_quantity(string id, int _quatity)
        {
            var i = listXe.Find(s => s.xeduocdat.MaXe.ToString() == id);
            if(i != null)
            {
                i._soLuongHang = _quatity;
            }
        }

        public double sum()
        {
            var sum = listXe.Sum(s => s._soLuongHang * 1);
            return sum;
        }

        public void remove (int id)
        {
            listXe.RemoveAll(s => s.xeduocdat.MaXe == id);
        }

        public int Total()
        {
            return listXe.Sum(s => s._soLuongHang);
        }        
    }
}