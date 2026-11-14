using CommunityToolkit.Mvvm.ComponentModel;
using LinqToDB;
using Suite.App.DataModel;
using LinqToDB.DataProvider.SQLite;
using System.IO;
using System;

namespace Suite.App.ViewModels;

public partial class MainViewModel : ObservableObject
{
    public MainViewModel()
    {
        string dbPath = Environment.GetEnvironmentVariable("SUITE_DB") is { Length: > 0 } path
            ? path
            : Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Suite", "SuiteDB.sqlite");
        DataOptions<DbContext> dataOptions = new(new DataOptions().UseSQLite($"Data Source={dbPath}", SQLiteProvider.Microsoft));
        DbContext dbContext = new(dataOptions);
        SelectedMailbox = dbContext.Mailboxes.Find(0);
    }

    [ObservableProperty]
    public partial Mailbox? SelectedMailbox { get; set; }
}
