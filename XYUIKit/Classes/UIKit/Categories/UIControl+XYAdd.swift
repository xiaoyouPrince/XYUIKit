//
//  UIControl+XYAdd.swift
//  XYUIKit
//
//  Created by 渠晓友 on 2022/6/30.
//

import Foundation

public protocol XYUIControlAddBlockTargetsProtocol {
    func removeAllTargets()
    func setTarget(target: Any, action: Selector, for controlEvents: UIControl.Event)
    func addBlock(for controlEvents: UIControl.Event, block:@escaping (_ sender: Any)->())
    func setBlock(for controlEvents: UIControl.Event, block:@escaping (_ sender: Any)->())
    func removeAllBlocks(for controlEvents: UIControl.Event)
}

extension UIControl: XYUIControlAddBlockTargetsProtocol {
    
    public func removeAllTargets() {
        for target in self.allTargets {
            removeTarget(target, action: nil, for: .allEvents)
        }
        allUIControlBlockTargets.removeAll()
    }
    
    public func setTarget(target: Any, action: Selector, for controlEvents: Event) {
        for ( _, target) in self.allTargets.enumerated(){
            if let actions = self.actions(forTarget: target, forControlEvent: controlEvents){
                for action in actions {
                    self.removeTarget(target, action: Selector(stringLiteral: action), for: controlEvents)
                }
            }
        }
        addTarget(target, action: action, for: controlEvents)
    }
    
    public func addBlock(for controlEvents: Event, block: @escaping (_ sender: Any) -> ()) {
        let target = XYUIControlBlockTarget(block: block, events: controlEvents)
        addTarget(target, action: #selector(target.invoke(_:)), for: controlEvents)
        allUIControlBlockTargets.append(target)
    }
    
    public func setBlock(for controlEvents: Event, block: @escaping (Any) -> ()) {
        removeAllBlocks(for: .allEvents)
        addBlock(for: controlEvents, block: block)
    }
    
    public func removeAllBlocks(for controlEvents: Event) {
        var targets = allUIControlBlockTargets
        var removes: [XYUIControlBlockTarget] = []
        
        for target in targets {
            if target.events == controlEvents {
                removeTarget(target, action: #selector(target.invoke(_:)), for: target.events)
                removes.append(target)
            }
        }
        
        for remove in removes {
            if let index = targets.firstIndex(where: {$0.id == remove.id}) {
                targets.remove(at: index)
            }
        }
    }
    
    class XYUIControlBlockTarget {
        
        var id: UUID
        var block: ((_ sender: Any) -> ())
        var events: UIControl.Event
        
        init(block: @escaping (_ sender: Any) -> (), events: UIControl.Event) {
            self.block = block
            self.events = events
            
            self.id = UUID()
        }
        
        @objc func invoke(_ sender: Any) {
            block(sender)
        }
    }
    
    private struct RuntimeKey {
        static let blockKey = "blockKey"
    }
    private var allUIControlBlockTargets: [XYUIControlBlockTarget] {
        set{
            objc_setAssociatedObject(self, UIControl.RuntimeKey.blockKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get{
            if objc_getAssociatedObject(self, UIControl.RuntimeKey.blockKey) != nil {
                return objc_getAssociatedObject(self, UIControl.RuntimeKey.blockKey) as! [XYUIControlBlockTarget]
            }else{
                self.allUIControlBlockTargets = []
                return []
            }
        }
    }
}
