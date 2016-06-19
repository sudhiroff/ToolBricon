using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

public static class Constant
{
    public static string UserName = "";
}

public static class DateFormater
{
    public static string GetDate(DateTime date)
    {
        if (date != null)
            return date.ToString("dd/MM/yyyy");
        else
            return "";
    }

    public static DateTime ConvertToDate(string date)
    {
        //if (String.IsNullOrEmpty(date))
        //    return null;
        //else
            return DateTime.ParseExact(date, "dd/MM/yyyy", null);
    }
}
