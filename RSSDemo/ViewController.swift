//
//  ViewController.swift
//  RSSDemo
//
//  Created by Satish Kumar on 16/06/17.
//  Copyright © 2017 SatishKumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var dummydata = ["One","Two","Three"]
    var SongsData:[TopSongs] = []
    var  eName: String = String()
    var songsTitle = String()
    var songsArtist = String()
    @IBOutlet var rssTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string:"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/topsongs/limit=25/xml")
        if let parser = XMLParser(contentsOf: url!) {
            parser.delegate = self
            parser.parse()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SongsData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cellID"
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) else{
                return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: cellIdentifier)
            }
            return cell
        }()
        
        let TopSongs = SongsData[indexPath.row]
        
        cell.textLabel?.text = TopSongs.songsTitle
        cell.detailTextLabel?.text = TopSongs.songsArtist
        
        return cell
        
    }
}
extension ViewController: XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        eName = elementName
        if elementName == "entry" {
            songsTitle = String()
            songsArtist = String()
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "entry" {
            let topsSongs = TopSongs()
            topsSongs.songsTitle = songsTitle
            topsSongs.songsArtist = songsArtist
            
            SongsData.append(topsSongs)
            
        }
        
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !data.isEmpty {
            if eName == "title" {
                
                songsTitle += data
                
            }else if eName == "im:artist"{
                
                songsArtist += data
            }
        }
        
   
    }

}

