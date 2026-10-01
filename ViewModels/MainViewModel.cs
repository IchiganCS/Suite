using CommunityToolkit.Mvvm.ComponentModel;
using LinqToDB;
using Suite.DataModel;
using LinqToDB.DataProvider.SQLite;

namespace Suite.ViewModels;

public partial class MainViewModel : ViewModelBase
{
    public MainViewModel()
    {
        DataOptions<DbContext> dataOptions = new(new DataOptions().UseSQLite("Data Source=/home/samuel/code/Suite/Database/MockData.sqlite", SQLiteProvider.Microsoft));
        DbContext dbContext = new(dataOptions);
        SelectedMailbox = dbContext.Mailboxes.Find(0);
    }

    [ObservableProperty]
    public partial Mailbox? SelectedMailbox { get; set; }
}
